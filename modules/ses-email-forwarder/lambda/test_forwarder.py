"""Unit tests for the SES email forwarder Lambda (forwarder.py).

The module reads env vars and creates boto3 clients at import time, so the
fixture sets the environment and patches ``boto3.client`` before importing.
"""

import importlib
import logging
import sys
from unittest import mock

import pytest

_ENV = {
    "FORWARDING_MAP": (
        '{"infrastructure": "infra@dest.com", '
        '"felipe": "me@dest.com", '
        '"*": "catchall@dest.com"}'
    ),
    "FROM_EMAIL": "noreply@flemming.com.br",
    "EMAIL_BUCKET": "emails-bucket",
}

_RAW = b"From: sender@external.example\r\nSubject: hi\r\n\r\nbody"


def _body(data: bytes):
    m = mock.MagicMock()
    m.read.return_value = data
    return m


def _ses_event(recipients, message_id="msg-1"):
    return {
        "Records": [
            {
                "ses": {
                    "mail": {"messageId": message_id},
                    "receipt": {"recipients": recipients},
                }
            }
        ]
    }


@pytest.fixture
def fw(monkeypatch):
    for key, value in _ENV.items():
        monkeypatch.setenv(key, value)
    fake_s3, fake_ses, fake_sts = mock.MagicMock(), mock.MagicMock(), mock.MagicMock()
    fake_sts.get_caller_identity.return_value = {"Account": "123456789012"}
    fake_s3.get_object.return_value = {"Body": _body(_RAW)}
    clients = {"s3": fake_s3, "ses": fake_ses, "sts": fake_sts}
    with mock.patch("boto3.client", side_effect=lambda name, *a, **k: clients[name]):
        sys.modules.pop("forwarder", None)
        module = importlib.import_module("forwarder")
        yield module
    sys.modules.pop("forwarder", None)


# --- _mask -----------------------------------------------------------------

def test_mask_hides_local_part(fw):
    assert fw._mask("felipe@gmail.com") == "f***@gmail.com"


def test_mask_non_email_is_redacted(fw):
    assert fw._mask("not-an-email") == "<redacted>"
    assert fw._mask(None) == "<redacted>"


# --- _forward --------------------------------------------------------------

def test_forward_known_recipient_sends(fw):
    sent = fw._forward(_RAW, "infrastructure@flemming.com.br")
    assert sent is True
    fw.ses.send_raw_email.assert_called_once()
    kwargs = fw.ses.send_raw_email.call_args.kwargs
    assert kwargs["Source"] == "noreply@flemming.com.br"
    assert kwargs["Destinations"] == ["infra@dest.com"]


def test_forward_catchall_for_unknown_local_part(fw):
    assert fw._forward(_RAW, "random@flemming.com.br") is True
    assert fw.ses.send_raw_email.call_args.kwargs["Destinations"] == ["catchall@dest.com"]


def test_forward_no_rule_skips(fw, monkeypatch):
    monkeypatch.setattr(fw, "FORWARDING_MAP", {"infrastructure": "infra@dest.com"})
    assert fw._forward(_RAW, "unknown@flemming.com.br") is False
    fw.ses.send_raw_email.assert_not_called()


def test_forward_invalid_recipient_skips(fw):
    assert fw._forward(_RAW, "not-an-email") is False
    assert fw._forward(_RAW, None) is False
    fw.ses.send_raw_email.assert_not_called()


# --- handler: the fan-out guarantee ----------------------------------------

def test_one_recipient_failure_does_not_drop_the_others(fw):
    # The 2nd send raises; the 1st and 3rd must still be attempted (no abort,
    # no re-raise). This is the regression test for feedback_fanout_per_item.
    fw.ses.send_raw_email.side_effect = [None, RuntimeError("throttled"), None]
    event = _ses_event(["infrastructure@x.com", "felipe@x.com", "infrastructure@x.com"])
    result = fw.handler(event, None)
    assert fw.ses.send_raw_email.call_count == 3  # every recipient attempted
    assert result == {"forwarded": 2, "skipped": 0, "failed": 1}


def test_handler_counts_skips(fw, monkeypatch):
    monkeypatch.setattr(fw, "FORWARDING_MAP", {"infrastructure": "infra@dest.com"})
    result = fw.handler(_ses_event(["infrastructure@x.com", "nobody@x.com"]), None)
    assert result == {"forwarded": 1, "skipped": 1, "failed": 0}


def test_handler_malformed_record_is_skipped_not_crashed(fw):
    result = fw.handler({"Records": [{"not_ses": {}}]}, None)
    assert result == {"forwarded": 0, "skipped": 0, "failed": 1}


def test_handler_no_records(fw):
    assert fw.handler({}, None) == {"forwarded": 0, "skipped": 0, "failed": 0}
    assert fw.handler({"Records": []}, None) == {"forwarded": 0, "skipped": 0, "failed": 0}


def test_handler_s3_read_failure_skips_message(fw):
    fw.s3.get_object.side_effect = RuntimeError("AccessDenied")
    result = fw.handler(_ses_event(["a@x.com", "b@x.com"]), None)
    assert result == {"forwarded": 0, "skipped": 0, "failed": 2}


def test_full_pii_address_never_logged(fw, caplog):
    caplog.set_level(logging.INFO)
    fw.handler(_ses_event(["felipe@flemming.com.br"]), None)
    blob = " ".join(rec.getMessage() for rec in caplog.records)
    assert "me@dest.com" not in blob                # destination PII redacted
    assert "felipe@flemming.com.br" not in blob     # recipient logged masked
