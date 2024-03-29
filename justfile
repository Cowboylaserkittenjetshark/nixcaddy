caddy := "github.com/caddyserver/caddy/v2"

# Make package for specified version (defaults to latest)
sync version="latest":
    go get -u {{caddy}}@{{version}}
    go mod tidy
    gomod2nix

# Make package for latest version (same as default sync)
update: (sync "latest")

add-modules +modules:
    echo "Not implemented, but I would add these modules: {{modules}}"
