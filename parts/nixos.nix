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
      homeOverlays = ["ai"];
    };

    boreal = {
      hostName = "boreal";
      userName = "gars";
      systemProfile = "sway-full";
      homeProfile = "sway-full";
      homeOverlays = ["ai"];
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
      homeOverlays = ["ai"];
    };

    rpi4-sway = {
      hostName = "rpi4";
      userName = "gars";
      systemProfile = "sway";
      homeProfile = "sway";
      homeOverlays = ["ai"];
    };
  };

  # ── jtop outputs (Janine's laptop) ────────────────────────────────
  # gars is the admin user and janine the everyday user; both can log into
  # COSMIC from cosmic-greeter. Extra users take the same arguments as the
  # primary user (see mkOutput); she gets the shared home modules like everyone
  # else.
  jtopOutputDefs = {
    jtop = {
      hostName = "jtop";
      userName = "gars";
      systemProfile = "cosmic";
      homeProfile = "cosmic";
      homeOverlays = [];
      extraHomeUsers.janine = {
        homeProfile = "cosmic";
        hostHomeModules = [
          (self + /hosts/jtop/janine-home.nix)
          (self + /hosts/jtop/janine-cosmic.nix)
        ];
      };
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

  nixosOutputDefs = borealOutputDefs // rpi4OutputDefs // jtopOutputDefs // otherOutputDefs;
in {
  flake.nixosConfigurations = builtins.mapAttrs (_: mkOutput) nixosOutputDefs;
}
