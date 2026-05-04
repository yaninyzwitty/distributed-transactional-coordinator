-- +goose Up
CREATE TYPE transaction_state AS ENUM ('PREPARING', 'PREPARED', 'COMMITTING', 'COMMITTED', 'ABORTING', 'ABORTED');
CREATE TYPE participant_state AS ENUM ('PENDING', 'PREPARED', 'COMMITTED', 'ABORTED');
CREATE TYPE compensation_event_type AS ENUM ('PREPARE_SENT', 'VOTE_RECEIVED', 'COMMIT_SENT', 'ABORT_SENT', 'COMMITTED', 'ABORTED');

-- +goose Down
DROP TYPE compensation_event_type;
DROP TYPE participant_state;
DROP TYPE transaction_state;
