-- name: CreateTransaction :one
INSERT INTO distributed_transactions (
    id,
    correlation_id,
    idempotency_key,
    state,
    metadata
)
VALUES (
    $1,
    $2,
    $3,
    'initiated',
    $4
)
RETURNING *;


-- name: TransitionTransactionState :one
UPDATE distributed_transactions
SET
    state = $2,
    version = version + 1,
    updated_at = now()
WHERE id = $1
AND version = $3
RETURNING *;


-- name: GetTransaction :one
SELECT *
FROM distributed_transactions
WHERE id = $1;


-- name: CompleteTransaction :exec
UPDATE distributed_transactions
SET
    completed_at = now(),
    recovery_needed = false,
    updated_at = now()
WHERE id = $1;