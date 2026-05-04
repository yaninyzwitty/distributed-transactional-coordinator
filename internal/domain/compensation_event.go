package domain

import (
	"time"

	"github.com/google/uuid"
)

type CompensationEventType string

const (
	CompensationEventTypePrepareSent  CompensationEventType = "PREPARE_SENT"
	CompensationEventTypeVoteReceived CompensationEventType = "VOTE_RECEIVED"
	CompensationEventTypeCommitSent   CompensationEventType = "COMMIT_SENT"
	CompensationEventTypeAbortSent    CompensationEventType = "ABORT_SENT"
	CompensationEventTypeCommitted    CompensationEventType = "COMMITTED"
	CompensationEventTypeAborted      CompensationEventType = "ABORTED"
)

type CompensationEvent struct {
	ID            int64                  `json:"id"`
	TransactionID uuid.UUID             `json:"transaction_id"`
	EventType     CompensationEventType `json:"event_type"`
	ParticipantID *string               `json:"participant_id"`
	Payload       interface{}           `json:"payload"` // JSONB as interface{}
	CreatedAt     time.Time             `json:"created_at"`
}