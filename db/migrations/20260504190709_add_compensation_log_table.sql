-- +goose Up
CREATE TABLE compensation_log (
    id serial PRIMARY KEY,
    transaction_id uuid NOT NULL REFERENCES transactions(id),
    event_type compensation_event_type NOT NULL,
    participant_id text,
    payload jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- +goose Down
DROP TABLE compensation_log;
