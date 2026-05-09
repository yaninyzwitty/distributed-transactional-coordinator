# Show help for available db recipes
default:
    @just --justfile just/db.just --list

# Run goose up applying all pending migrations in db/migrations/
migrate:
    goose -dir db/migrations postgres "$DATABASE_URL" up

# Run goose down to roll back the last migration
migrate-down:
    goose -dir db/migrations postgres "$DATABASE_URL" down

# Run goose status to show applied/pending migrations
migrate-status:
    goose -dir db/migrations postgres "$DATABASE_URL" status

# Run goose reset to re-run all migrations from scratch
migrate-reset:
    goose -dir db/migrations postgres "$DATABASE_URL" reset

# Run goose seed from SQL seed files in scripts/ directory
seed:
    goose -dir db/migrations -seeds-dir scripts postgres "$DATABASE_URL" seed

# Show migration status + verify database connectivity
status:
    @echo "Migration status:"
    goose -dir db/migrations postgres "$DATABASE_URL" status
    @echo "Verifying database connectivity..."
    psql "$DATABASE_URL" -c "SELECT 1;" > /dev/null && echo "Database connected successfully" || echo "Database connection failed"