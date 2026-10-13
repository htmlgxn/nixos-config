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
  # gars is the admin user (cli home); janine is the desktop user, with the
  # same apps on either desktop. `jtop` (GNOME) is the default; `jtop-cosmic`
  # is a COSMIC trial on the same machine (switch with `nr jtop-cosmic`,
  # back with `nrs`; reboot after switching so the login screen changes).
  janine = desktop: {
    homeProfile = desktop;
    withSharedHomeModules = true;
    hostHomeModules = [
      (self + /hosts/jtop/janine-home.nix)
      (self + /hosts/jtop/janine-${desktop}.nix)
    ];
  };

  jtopOutputDefs = {
    jtop = {
      hostName = "jtop";
      userName = "gars";
      systemProfile = "gnome";
      homeProfile = "cli";
      homeOverlays = [];
      extraHomeUsers.janine = janine "gnome";
    };

    jtop-cosmic = {
      hostName = "jtop";
      userName = "gars";
      systemProfile = "cosmic";
      homeProfile = "cli";
      homeOverlays = [];
      extraHomeUsers.janine = janine "cosmic";
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
