-- name: GetRecoverableTransactions :many
SELECT *
FROM distributed_transactions
WHERE recovery_needed = true
AND state IN (
    'preparing',
    'prepared',
    'committing',
    'aborting'
)
ORDER BY created_at
LIMIT $1;


-- name: GetTransactionParticipants :many
SELECT *
FROM transaction_participants
WHERE transaction_id = $1;


-- name: GetStalledPreparedTransactions :many
SELECT *
FROM distributed_transactions
WHERE state = 'prepared'
AND updated_at < now() - interval '30 seconds';


-- name: IncrementRecoveryAttempts :exec
UPDATE distributed_transactions
SET
    recovery_attempts = recovery_attempts + 1,
    last_recovery_at = now()
WHERE id = $1;