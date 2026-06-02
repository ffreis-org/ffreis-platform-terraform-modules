# async-event-queue

Canonical **one-directional event-consumer unit** for the fleet. Replaces always-on
Lambda Event Source Mappings (which poll SQS ~130K req/month per queue at idle and
have no tunable interval) with a tunable, no-ESM trigger.

```
producer ─► [input SNS topic] ─┬─ near_real_time/batch ─► [SQS + DLQ] ─drain─► Lambda
                               ├─ real_time ───────────► Lambda ; on-failure ─► [SQS + DLQ]
                               └─ (optional) ──────────► Firehose ─► [S3 archive]   (replay)
   Lambda ─sns:Publish(result)─► [output topic]   (= the NEXT unit's input; there is NO output queue)
```

Composes the in-repo `sqs` and `sns` primitives. **The durable queue always belongs to
the consumer** — a Lambda's "output" is just the next unit's input, which already buffers
it, so there is no producer-side output queue.

## consumer_mode

| mode | trigger | SQS role | latency | idle cost |
|---|---|---|---|---|
| `real_time` | SNS → Lambda subscription (push) | failure-only queue (empty in normal op) | < 1 s | ~0 |
| `near_real_time` | EventBridge scheduled drain | primary buffer | = drain interval | drain-rate dependent |
| `batch` | EventBridge drain (cron) | primary buffer | 5 min–hours | very low |
| `external` | caller wires the trigger | primary buffer | — | — |

Drain cost is **tunable, not zero**: each scheduled invocation does one long-poll
`ReceiveMessage` even when empty (≈ `rate` × invocations/month). `rate(1m)` ≈ 43K/mo
(~3× cheaper than ESM); `rate(5m)` ≈ 8.6K; `rate(15m)` ≈ 2.9K. If a flow needs sub-minute
latency, use `real_time` (push), not `near_real_time` at `rate(1m)`.

## Caller responsibilities (the module cannot enforce these)

1. **Idempotency (mandatory).** Every hop is at-least-once. Make the consumer idempotent
   at the *side effect* (e.g. `PutItem` with `attribute_not_exists`, or an `email_sent_at`
   guard) — never a status flag flipped *before* the work (a mid-flight crash would then
   drop the work). Write `status = complete` only *after* the side effect.
2. **Reserved concurrency.** For `near_real_time`/`batch`, set
   `reserved_concurrent_executions = 1` on the consumer Lambda module so overlapping drains
   can't double-process. The module does not own the Lambda and cannot set this.
3. **`QUEUE_URL` env var.** Set it to `module.<unit>.queue_url` on the consumer Lambda
   (the drain handler reads it). For `real_time` this is the failure queue.
4. **IAM.** Attach the module's `*_policy_json` outputs to the relevant Lambda
   `inline_policies` (the module never creates IAM role attachments).
5. **`real_time` go-live.** Keep `real_time_subscription_enabled = false` and
   `failure_drain_enabled = false` until the handler ships; flip both at cutover (an SNS
   subscription cannot be created disabled, so creating it early would invoke an
   un-updated handler).
6. **Visibility timeout.** Set `visibility_timeout_seconds` ≥ the consumer Lambda timeout
   with margin (the existing 6× multiple is a good default).

## Archive + replay (D2)

`create_archive = true` archives every event on the input topic to S3 via Kinesis Firehose
(pay-per-use, no fixed cost), for full reprocessing. A separate replay job reads an S3
time-range and re-publishes to the input topic (use `replay_policy_json`); idempotency
makes that safe. DLQ re-drive covers *failed*-message replay separately.

> **⚠ NEVER `create_archive` on flows carrying secrets or PII.** Auth events contain
> plaintext passwords; archiving writes them to S3. Form events contain submitter PII.
> Archive is for non-secret content streams (e.g. the petlook product pipeline) only.

## Chaining

One unit per consumer. Chain by passing a unit's `output_topic_arn` as the next unit's
`external_input_topic_arn`; the downstream unit owns its input queue, queue policy, and
subscription. SNS fan-out is implicit — N downstream units subscribing their queues to one
output topic each get every (matching) message.

## Not yet supported

- `prevent_destroy`: Terraform requires `lifecycle.prevent_destroy` to be a literal (not a
  variable), and the in-repo `sqs` module does not expose it yet (see its
  `feat/prevent-destroy` branch). Manage destroy-protection there once it lands.
