-- +goose Up

CREATE TYPE IF NOT EXISTS compensation_status AS ENUM (
    'pending',
    'running',
    'completed',
    'failed'
);

CREATE TABLE IF NOT EXISTS compensation_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    transaction_id UUID NOT NULL
        REFERENCES distributed_transactions(id)
        ON DELETE CASCADE,

    participant_id UUID NOT NULL
        REFERENCES transaction_participants(id)
        ON DELETE CASCADE,

    sequence_no BIGINT NOT NULL,

    action_type TEXT NOT NULL,

    compensation_endpoint TEXT NOT NULL,

    request_payload JSONB NOT NULL,

    response_payload JSONB,

    status compensation_status NOT NULL DEFAULT 'pending',

    error_message TEXT,

    retry_count INT NOT NULL DEFAULT 0,

    executed_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- soft delete
    deleted_at TIMESTAMPTZ NULL
);

CREATE INDEX IF NOT EXISTS idx_comp_pending
ON compensation_logs(status);

CREATE INDEX IF NOT EXISTS idx_comp_tx_seq
ON compensation_logs(transaction_id, sequence_no);

-- +goose Down
DROP INDEX IF EXISTS idx_comp_pending;
DROP INDEX IF EXISTS idx_comp_tx_seq;
DROP TYPE IF EXISTS compensation_status;
DROP TABLE IF EXISTS compensation_logs;
