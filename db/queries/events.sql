-- name: AppendTransactionEvent :exec
INSERT INTO transaction_events (
    transaction_id,
    participant_id,
    event_type,
    event_data
)
VALUES (
    $1,
    $2,
    $3,
    $4
);


-- name: GetTransactionTimeline :many
SELECT *
FROM transaction_events
WHERE transaction_id = $1
ORDER BY created_at;