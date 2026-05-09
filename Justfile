DATABASE_URL := `doppler secrets get DATABASE_URL --no-file`

# Show help (list available recipes)
default:
    @just --list

# Delegate to gen.just recipes
gen *args:
    @just --justfile just/gen.just {{args}}

# Delegate to db.just recipes
db *args:
    @just --justfile just/db.just {{args}}