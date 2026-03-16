#
# ~/nixos-config/modules/home/go.nix
#
{ pkgs, ... }: let
  bit = pkgs.buildGoModule {
    pname = "bit";
    version = "0.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "superstarryeyes";
      repo = "bit";
      rev = "v0.3.0";
      hash = "sha256-iLwWKn8csoRkr5H8R2kpZVZCxsL0LDWHNvNoxyM6y98=";
    };
    vendorHash = "sha256-REPLACE_ME";
    subPackages = [ "cmd/bit" ];
    modVendor = true;
  };
in {
  home.packages = with pkgs; [
    # ── Toolchain ────────────────────────────────────────────────────
    go

    # ── Custom Tools ────────────────────────────────────────────────
    bit # ANSI logo designer
  ];
}
