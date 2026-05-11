set shell := ["pwsh", "-Command"]

export DOPPLER_TOKEN := env_var_or_default("DOPPLER_TOKEN", "")
default:
    @just --list

gen *args:
    $env:DATABASE_URL = $(doppler secrets get DATABASE_URL --plain); just --justfile just/gen.just {{args}}

db *args:
    $env:DATABASE_URL = $(doppler secrets get DATABASE_URL --plain); just --justfile just/db.just {{args}}