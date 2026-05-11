-- name: AppendCompensationLog :one
INSERT INTO compensation_logs (
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


-- name: DequeuePendingCompensations :many
UPDATE compensation_logs
SET status = 'running'
WHERE id IN (
    SELECT id
    FROM compensation_logs
    WHERE status IN ('pending', 'failed')
    ORDER BY sequence_no DESC
    LIMIT $1
)
RETURNING *;


-- name: MarkCompensationRunning :exec
UPDATE compensation_logs
SET status = 'running'
WHERE id = $1 AND status = 'pending';


-- name: CompleteCompensation :exec
UPDATE compensation_logs
SET
    status = 'completed',
    response_payload = $2,
    executed_at = now()
WHERE id = $1 AND status = 'running';


-- name: FailCompensation :exec
UPDATE compensation_logs
SET
    status = 'failed',
    error_message = $2,
    retry_count = retry_count + 1
WHERE id = $1 AND status = 'running';