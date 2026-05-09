-- name: AppendCompensationLog :one
INSERT INTO compensation_log (
    transaction_id,
    participant_id,
    sequence_no,
    action_type,
    compensation_endpoint,
    request_payload,
    status
)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    'pending'
)
RETURNING *;


-- name: GetPendingCompensations :many
SELECT *
FROM compensation_log
WHERE status IN ('pending', 'failed')
ORDER BY sequence_no DESC
LIMIT $1;


-- name: MarkCompensationRunning :exec
UPDATE compensation_log
SET status = 'running'
WHERE id = $1;


-- name: CompleteCompensation :exec
UPDATE compensation_log
SET
    status = 'completed',
    response_payload = $2,
    executed_at = now()
WHERE id = $1;


-- name: FailCompensation :exec
UPDATE compensation_log
SET
    status = 'failed',
    error_message = $2,
    retry_count = retry_count + 1
WHERE id = $1;