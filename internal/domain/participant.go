package domain

import (
	"time"

	"github.com/google/uuid"
)

type ParticipantState string

const (
	ParticipantStatePending   ParticipantState = "PENDING"
	ParticipantStatePrepared  ParticipantState = "PREPARED"
	ParticipantStateCommitted ParticipantState = "COMMITTED"
	ParticipantStateAborted   ParticipantState = "ABORTED"
)

type Participant struct {
	TransactionID uuid.UUID        `json:"transaction_id"`
	ParticipantID string          `json:"participant_id"`
	Endpoint      string          `json:"endpoint"`
	State         ParticipantState `json:"state"`
	VotedAt       *time.Time      `json:"voted_at"`
}