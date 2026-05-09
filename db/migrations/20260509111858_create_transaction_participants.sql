-- +goose Up

CREATE TYPE participant_state AS ENUM (
    'registered',
    'prepare_sent',
    'prepared',
    'prepare_failed',
    'commit_sent',
    'committed',
    'abort_sent',
    'aborted',
    'heuristic_commit',
    'heuristic_abort',
    'timeout'
);

CREATE TABLE IF NOT EXISTS transaction_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    transaction_id UUID NOT NULL
        REFERENCES distributed_transactions(id)
        ON DELETE CASCADE,

    participant_name TEXT NOT NULL,

    -- endpoint info
    service_name TEXT NOT NULL,
    endpoint TEXT NOT NULL,

    -- protocol state
    state participant_state NOT NULL,

    -- deterministic replay
    prepare_token TEXT,
    commit_token TEXT,

    -- response payloads
    prepare_response JSONB,
    commit_response JSONB,
    abort_response JSONB,

    -- compensation
    compensation_endpoint TEXT,
    compensation_payload JSONB,

    -- retry/recovery
    retry_count INT NOT NULL DEFAULT 0,
    last_retry_at TIMESTAMPTZ,

    -- timing
    prepared_at TIMESTAMPTZ,
    committed_at TIMESTAMPTZ,
    aborted_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- soft delete
    deleted_at TIMESTAMPTZ NULL,

    UNIQUE(transaction_id, participant_name)
);

CREATE INDEX IF NOT EXISTS idx_participant_tx
ON transaction_participants(transaction_id);

-- +goose Down
DROP INDEX IF EXISTS idx_participant_tx;
DROP TYPE IF EXISTS participant_state;
DROP TABLE IF EXISTS transaction_participants;
