export DOPPLER_TOKEN := env("DOPPLER_TOKEN")
default:
    @just --list

gen *args:
    DATABASE_URL="$(doppler secrets get DATABASE_URL --no-file --plain)" \
    just --justfile just/gen.just {{args}}

db *args:
    DATABASE_URL="$(doppler secrets get DATABASE_URL --no-file --plain)" \
    just --justfile just/db.just {{args}}