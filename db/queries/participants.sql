-- name: RegisterParticipant :one
INSERT INTO transaction_participants (
    id,
    transaction_id,
    participant_name,
    service_name,
    endpoint,
    state
)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    'registered'
)
RETURNING *;


-- name: MarkParticipantPrepared :exec
UPDATE transaction_participants
SET
    state = 'prepared',
    prepare_token = $2,
    prepared_at = now(),
    updated_at = now()
WHERE id = $1;


-- name: MarkParticipantCommitted :exec
UPDATE transaction_participants
SET
    state = 'committed',
    committed_at = now(),
    updated_at = now()
WHERE id = $1;


-- name: MarkParticipantAborted :exec
UPDATE transaction_participants
SET
    state = 'aborted',
    aborted_at = now(),
    updated_at = now()
WHERE id = $1;


-- name: CountUnpreparedParticipants :one
SELECT COUNT(*)
FROM transaction_participants
WHERE transaction_id = $1
AND state != 'prepared';