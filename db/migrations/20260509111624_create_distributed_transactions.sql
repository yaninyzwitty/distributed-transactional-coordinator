-- +goose Up
CREATE TYPE tx_state AS ENUM (
    'initiated',
    'preparing',
    'prepared',
    'committing',
    'committed',
    'aborting',
    'aborted',
    'recovering',
    'failed'
);

CREATE TABLE IF NOT EXISTS distributed_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- external/business correlation
    correlation_id TEXT,
    idempotency_key TEXT,

    -- coordinator state
    state tx_state NOT NULL,

    -- recovery metadata
    recovery_needed BOOLEAN NOT NULL DEFAULT FALSE,
    recovery_attempts INT NOT NULL DEFAULT 0,
    last_recovery_at TIMESTAMPTZ,

    -- timing
    prepare_deadline TIMESTAMPTZ,
    commit_deadline TIMESTAMPTZ,

    -- versioning / optimistic locking
    version BIGINT NOT NULL DEFAULT 0,

    -- payload metadata
    metadata JSONB,

    -- timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,

    -- soft delete
    deleted_at TIMESTAMPTZ NULL
);

-- index for efficient participant lookups
CREATE INDEX IF NOT EXISTS idx_tx_state
ON distributed_transactions(state);

CREATE INDEX IF NOT EXISTS idx_tx_recovery
ON distributed_transactions(recovery_needed);



-- +goose Down
DROP INDEX IF EXISTS idx_tx_state;
DROP INDEX IF EXISTS idx_tx_recovery;
DROP TYPE IF EXISTS tx_state;
DROP TABLE IF EXISTS distributed_transactions;