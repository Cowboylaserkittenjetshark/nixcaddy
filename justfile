set positional-arguments := true

caddy := "github.com/caddyserver/caddy/v2"

default:
    just --list

# Make package for specified version (defaults to latest)
sync version:
    #!/usr/bin/env bash
    set -euo pipefail

    version={{version}}
    if [[ $version != "latest" ]]; then
        echo "Got non-latest version string"
        if [[ ${1:0:1} != 'v' ]]; then
            version="v$1"
        fi
    fi

    echo "Upgrading to version $version"

    go get {{caddy}}@$version
    go mod tidy
    VERSION=$(rg "^.*github\.com\/caddyserver\/caddy\/v2 v(\d+\.\d+\.\d+)" go.mod --trim -N -r '$1')
    sed -i 's|version\s*=\s*"[0-9]\+\.[0-9]\+\.[0-9]\+.*"|version = "'"$VERSION"'"|' default.nix
    gomod2nix

    if [[ $version == "latest" ]]; then
        override=""
    else
        override=" --override-input dist "git+https://github.com/caddyserver/dist?ref=refs/tags/$version""
    fi

    if nix flake update dist $override; then
        echo "Succesfully upgraded dist"
    else 
        printf "\n###################################################\n"
        printf "Failed to update dist, manual intervention required\n"
        printf "###################################################\n"
        printf "Check https://github.com/caddyserver/dist/tags for the last tag before the version of caddy you specified and run:\n"
        printf "\tnix flake update dist --override-input dist "git+https://github.com/caddyserver/dist?ref=refs/tags/{name_of_tag}"\n\n"
        printf "Example: You specified Caddy v2.8.3 but no dist release exists for this version -> You need dist v2.8.2:\n"
        printf "\tnix flake update dist --override-input dist "git+https://github.com/caddyserver/dist?ref=refs/tags/v2.8.2"\n"
        
    fi

# Make package for latest version (same as default sync)
update: (sync "latest")
