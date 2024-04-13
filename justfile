caddy := "github.com/caddyserver/caddy/v2"

# Make package for specified version (defaults to latest)
sync version="latest":
    go get {{caddy}}@{{version}}
    go mod tidy
    gomod2nix

# Make package for latest version (same as default sync)
update: (sync "latest")
