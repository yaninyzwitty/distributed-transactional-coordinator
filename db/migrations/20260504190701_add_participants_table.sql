-- +goose Up
CREATE TABLE participants (
    transaction_id uuid NOT NULL REFERENCES transactions(id),
    participant_id text NOT NULL,
    endpoint text NOT NULL,
    state participant_state NOT NULL,
    voted_at timestamptz,
    PRIMARY KEY (transaction_id, participant_id)
);

-- +goose Down
DROP TABLE participants;
