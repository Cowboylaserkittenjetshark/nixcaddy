# nixcaddy
Generate nix packages for Caddy with plugins.

The `main` branch functions as a template. For an example, see the branch `my-plugins`.
## Getting Started
1. Either:
    1. Clone this repository and use it locally (eg. `callPackage` or a local flake input)
    2. Fork this repository and add it to your flake inputs (eg. `inputs.custom-caddy.url = "github:your_username/nixcaddy";`)
2. Add your modules to the `main.go` file at the root of the repository
3. Enter the dev shell: `nix develop`
4. Run `just update` to update the go module
5. Commit changes (and push upstream if applicable)

You can then override the caddy package with your own:
```nix
# Example nixos module
# Emits a warning during build if nixcaddy is outdated compared to nixpkgs' caddy
{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) warnIfNot versionAtLeast;
  customCaddyPkg = inputs.custom-caddy.packages.${pkgs.system}.default;
  defaultCaddyPkg = pkgs.caddy;
in {
  services.caddy = {
    enable = true;
    package =   
        lib.warnIfNot
        (lib.versionAtLeast customCaddyPkg.version defaultCaddyPkg.version)
        ''          The version of Caddy in the package is older than the version in your version of nixpkgs
                      Caddy from nixpkgs:  ${defaultCaddyPkg.version}
                      Caddy form nixcaddy: ${customCaddyPkg.version}
        ''
        customCaddyPkg;
      };
    }
```
