"""
SES inbound email forwarder.

Triggered by an SES receipt rule. Reads the raw email from S3 (stored by the
preceding S3 action in the same rule), rewrites the From/To/Reply-To headers,
and re-sends via SES to the configured destination address.

Environment variables:
  FORWARDING_MAP   JSON object mapping lower-case local-part → destination email.
                   Use "*" as a catch-all key.
                   Example: {"infrastructure":"me@gmail.com","felipefuhrdosreis":"me@gmail.com"}
  FROM_EMAIL       SES-verified sender address used for the forwarded message.
  EMAIL_BUCKET     S3 bucket where SES stores raw emails.
  EMAIL_KEY_PREFIX S3 key prefix (no trailing slash). Default: "emails".
"""

import boto3
import copy
import email
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

FORWARDING_MAP: dict = json.loads(os.environ["FORWARDING_MAP"])
FROM_EMAIL: str = os.environ["FROM_EMAIL"]
EMAIL_BUCKET: str = os.environ["EMAIL_BUCKET"]
EMAIL_KEY_PREFIX: str = os.environ.get("EMAIL_KEY_PREFIX", "emails")

s3 = boto3.client("s3")
ses = boto3.client("ses")
sts = boto3.client("sts")

# Resolved once at cold start to avoid per-invocation STS latency.
_AWS_ACCOUNT_ID: str = sts.get_caller_identity()["Account"]

# Headers that must be removed before re-sending to avoid delivery failures.
_STRIP_HEADERS = [
    "DKIM-Signature",
    "DomainKey-Signature",
    "Received",
    "Return-Path",
    "Sender",
    "Message-ID",
]


def _mask(addr: object) -> str:
    """Mask an email address for logging.

    CloudWatch logs are retained for a long time, so we never write a full
    address (PII). Keep the local-part initial and the domain so operators can
    still tell aliases apart: ``felipe@gmail.com`` -> ``f***@gmail.com``.
    """
    if not isinstance(addr, str) or "@" not in addr:
        return "<redacted>"
    local, _, domain = addr.partition("@")
    head = local[0] if local else ""
    return f"{head}***@{domain}"


def _forward(raw: bytes, recipient: str) -> bool:
    """Forward one recipient's copy.

    Returns ``True`` if the message was sent, ``False`` if the recipient was
    skipped (invalid address or no matching forwarding rule). Raises on an
    actual send/parse failure so the caller can count it — the caller must NOT
    let one recipient's failure abort the others.
    """
    if not isinstance(recipient, str) or "@" not in recipient:
        logger.warning("Invalid recipient address — skipping")
        return False

    local_part = recipient.split("@")[0].lower()
    destination = FORWARDING_MAP.get(local_part) or FORWARDING_MAP.get("*")

    if not destination:
        logger.warning("No forwarding rule for %s — skipping", _mask(recipient))
        return False

    msg = email.message_from_bytes(raw)
    original_from = msg.get("From", recipient)

    # Work on a fresh copy so multiple recipients don't see mutated headers.
    fwd = copy.deepcopy(msg)

    for hdr in _STRIP_HEADERS + ["From", "To", "Cc", "Reply-To"]:
        while hdr in fwd:
            del fwd[hdr]

    fwd["From"] = FROM_EMAIL
    fwd["To"] = destination
    fwd["Reply-To"] = original_from

    ses.send_raw_email(
        Source=FROM_EMAIL,
        Destinations=[destination],
        RawMessage={"Data": fwd.as_bytes()},
    )
    logger.info("Forwarded %s -> %s", _mask(recipient), _mask(destination))
    return True


def handler(event, context):
    """Forward every recipient of every SES record, best-effort.

    Per-recipient failures are logged and counted but never abort the loop or
    re-raise: a single bad recipient must not drop the rest, and re-raising
    would make SES retry the whole message and re-send to recipients that
    already succeeded (fan-out-per-item rule).
    """
    records = event.get("Records") if isinstance(event, dict) else None
    if not records:
        logger.warning("Event has no Records — nothing to forward")
        return {"forwarded": 0, "skipped": 0, "failed": 0}

    forwarded = skipped = failed = 0

    for record in records:
        try:
            ses_data = record["ses"]
            message_id = ses_data["mail"]["messageId"]
            recipients = ses_data["receipt"]["recipients"]
        except (KeyError, TypeError):
            logger.error("Malformed SES record (missing ses.mail/receipt) — skipping")
            failed += 1
            continue

        logger.info(
            "Processing message %s for %d recipient(s)", message_id, len(recipients)
        )

        key = f"{EMAIL_KEY_PREFIX}/{message_id}"
        try:
            raw = s3.get_object(
                Bucket=EMAIL_BUCKET,
                Key=key,
                ExpectedBucketOwner=_AWS_ACCOUNT_ID,
            )["Body"].read()
        except Exception:
            logger.exception(
                "Failed to read raw email %s from S3 — skipping message", message_id
            )
            failed += len(recipients)
            continue

        for recipient in recipients:
            try:
                if _forward(raw, recipient):
                    forwarded += 1
                else:
                    skipped += 1
            except Exception:
                logger.exception(
                    "Failed to forward message %s to %s", message_id, _mask(recipient)
                )
                failed += 1

    logger.info(
        "Forwarding complete: %d forwarded, %d skipped, %d failed",
        forwarded,
        skipped,
        failed,
    )
    return {"forwarded": forwarded, "skipped": skipped, "failed": failed}
