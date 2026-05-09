-- name: AcquireRecoveryLease :one
UPDATE distributed_transactions
SET
    coordinator_instance_id = $2,
    lease_expires_at = now() + interval '30 seconds'
WHERE id = $1
AND (
    lease_expires_at IS NULL
    OR lease_expires_at < now()
)
RETURNING *;


-- name: RenewRecoveryLease :exec
UPDATE distributed_transactions
SET
    lease_expires_at = now() + interval '30 seconds'
WHERE id = $1
AND coordinator_instance_id = $2;