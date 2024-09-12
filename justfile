caddy := "github.com/caddyserver/caddy/v2"

# Make package for specified version (defaults to latest)
sync version="latest":
    #!/usr/bin/env sh
    go get {{caddy}}@{{version}}
    go mod tidy
    VERSION=$(rg "github\.com\/caddyserver\/caddy\/v2 v(\d+\.\d+\.\d+)" go.mod --trim -N -r '$1')
    sed -i 's/version\s*=\s*"[0-9]\+\.[0-9]\+\.[0-9]\+"/version = "'"$VERSION"'"/' default.nix
    gomod2nix

# Make package for latest version (same as default sync)
update: (sync "latest")
