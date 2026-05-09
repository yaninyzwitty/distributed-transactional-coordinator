-- +goose Up

CREATE TABLE transaction_events (
    id BIGSERIAL PRIMARY KEY,

    transaction_id UUID NOT NULL
        REFERENCES distributed_transactions(id)
        ON DELETE CASCADE,

    participant_id UUID,

    event_type TEXT NOT NULL,

    event_data JSONB,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- +goose Down
DROP TABLE transaction_events;
