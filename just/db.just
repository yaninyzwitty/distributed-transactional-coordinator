set shell := ["bash", "-c"]

# Show help for available db recipes
default:
    @just --justfile just/db.just --list

# Run goose up applying all pending migrations in db/migrations/
migrate:
    #!pwsh
    cd ..
    $env:PATH = "$env:USERPROFILE\.local\share\mise\shims;$env:PATH"
    goose -dir db/migrations postgres $env:DATABASE_URL up

# Run goose down to roll back the last migration
migrate-down:
    #!pwsh
    cd ..
    $env:PATH = "$env:USERPROFILE\.local\share\mise\shims;$env:PATH"
    goose -dir db/migrations postgres $env:DATABASE_URL down

# Run goose status to show applied/pending migrations
migrate-status:
    #!pwsh
    cd ..
    $env:PATH = "$env:USERPROFILE\.local\share\mise\shims;$env:PATH"
    goose -dir db/migrations postgres $env:DATABASE_URL status

# Run goose reset to re-run all migrations from scratch
migrate-reset:
    #!pwsh
    cd ..
    $env:PATH = "$env:USERPROFILE\.local\share\mise\shims;$env:PATH"
    goose -dir db/migrations postgres $env:DATABASE_URL reset

# Run goose seed from SQL seed files in scripts/ directory
seed:
    #!pwsh
    cd ..
    $env:PATH = "$env:USERPROFILE\.local\share\mise\shims;$env:PATH"
    goose -dir db/migrations -seeds-dir scripts postgres $env:DATABASE_URL seed

# Show migration status + verify database connectivity
status:
    #!pwsh
    cd ..
    Write-Host "Migration status:"
    $env:PATH = "$env:USERPROFILE\.local\share\mise\shims;$env:PATH"
    goose -dir db/migrations postgres $env:DATABASE_URL status
    Write-Host "Verifying database connectivity..."
    psql $env:DATABASE_URL -c "SELECT 1;" > $null
    if ($LASTEXITCODE -eq 0) { Write-Host "Database connected successfully" } else { Write-Host "Database connection failed" }