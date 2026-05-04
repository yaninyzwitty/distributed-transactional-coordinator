package domain

import (
	"time"

	"github.com/google/uuid"
)

type TransactionState string

const (
	TransactionStatePreparing  TransactionState = "PREPARING"
	TransactionStatePrepared   TransactionState = "PREPARED"
	TransactionStateCommitting TransactionState = "COMMITTING"
	TransactionStateCommitted  TransactionState = "COMMITTED"
	TransactionStateAborting   TransactionState = "ABORTING"
	TransactionStateAborted    TransactionState = "ABORTED"
)

type Transaction struct {
	ID        uuid.UUID       `json:"id"`
	State     TransactionState `json:"state"`
	CreatedAt time.Time       `json:"created_at"`
	UpdatedAt time.Time       `json:"updated_at"`
	TimeoutAt time.Time       `json:"timeout_at"`
}