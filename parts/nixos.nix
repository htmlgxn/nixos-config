# parts/nixos.nix
#
# NixOS output definitions, grouped by host.
# Each entry selects a host, user, system profile, home profile,
# and optional home overlay groups. See docs/reference.md for the full matrix.
{
  self,
  flakeLib,
  ...
}: let
  inherit (flakeLib) mkOutput;

  borealOverlay = import (self + /overlays/brave-nightly.nix);

  # ── Boreal outputs ────────────────────────────────────────────────
  borealOutputDefs = {
    boreal-tty = {
      hostName = "boreal";
      userName = "gars";
      systemProfile = "tty";
      homeProfile = "cli";
      homeOverlays = ["cli-extras" "ai-cli-all" "ai-ollama-rocm"];
    };

    boreal = {
      hostName = "boreal";
      userName = "gars";
      systemProfile = "sway";
      homeProfile = "sway";
      homeOverlays = ["cli-extras" "boreal-gui" "boreal-desktop"];
      nixpkgsOverlays = [borealOverlay];
    };
  };

  # ── Raspberry Pi 4 outputs ────────────────────────────────────────
  rpi4OutputDefs = {
    rpi4-tty = {
      hostName = "rpi4";
      userName = "gars";
      systemProfile = "tty";
      homeProfile = "cli";
      homeOverlays = [];
    };

    rpi4-sway = {
      hostName = "rpi4";
      userName = "gars";
      systemProfile = "sway-arm";
      homeProfile = "sway-arm";
      homeOverlays = [];
    };
  };

  # ── Other outputs ─────────────────────────────────────────────────
  otherOutputDefs = {
    nixos-vm = {
      hostName = "nixos-vm";
      userName = "gars";
      systemProfile = "tty";
      homeProfile = "cli";
      homeOverlays = [];
    };

    # cyberdeck-tty = {
    #   hostName = "cyberdeck";
    #   userName = "gars";
    #   systemProfile = "tty";
    #   homeProfile = "cli";
    #   homeOverlays = [];
    # };
  };

  nixosOutputDefs = borealOutputDefs // rpi4OutputDefs // otherOutputDefs;
in {
  flake.nixosConfigurations = builtins.mapAttrs (_: cfg: mkOutput cfg) nixosOutputDefs;
}
