-- name: CreateTransaction :one
INSERT INTO transactions (state, updated_at, timeout_at)
VALUES ($1, $2, $3)
RETURNING id, state, created_at, updated_at, timeout_at;

-- name: GetTransaction :one
SELECT id, state, created_at, updated_at, timeout_at
FROM transactions
WHERE id = $1;

-- name: UpdateTransactionState :exec
UPDATE transactions
SET state = $2, updated_at = $3
WHERE id = $1;

-- name: GetExpiredTransactions :many
SELECT id, state, created_at, updated_at, timeout_at
FROM transactions
WHERE timeout_at < now() AND state NOT IN ('COMMITTED', 'ABORTED');

-- name: CreateParticipant :exec
INSERT INTO participants (transaction_id, participant_id, endpoint, state)
VALUES ($1, $2, $3, $4);

-- name: GetParticipantsByTransaction :many
SELECT transaction_id, participant_id, endpoint, state, voted_at
FROM participants
WHERE transaction_id = $1;

-- name: UpdateParticipantState :exec
UPDATE participants
SET state = $3, voted_at = $4
WHERE transaction_id = $1 AND participant_id = $2;

-- name: CreateCompensationEvent :exec
INSERT INTO compensation_log (transaction_id, event_type, participant_id, payload)
VALUES ($1, $2, $3, $4);

-- name: GetCompensationEventsByTransaction :many
SELECT id, transaction_id, event_type, participant_id, payload, created_at
FROM compensation_log
WHERE transaction_id = $1
ORDER BY created_at;