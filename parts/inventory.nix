# parts/inventory.nix
#
# What exists in this repo: users, hosts, profiles, overlay groups and the
# module sets every output shares. This is the file to edit when adding a
# user, host or profile; the builders that turn it into flake outputs live in
# parts/lib.nix, and the outputs themselves are selected in parts/nixos.nix,
# parts/darwin.nix and parts/home.nix.
#
# Order matters inside the module lists (later modules win ties and list
# options concatenate in this order), so append rather than re-sort.
{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs nixos-hardware;

  # ── Shared nixpkgs config (applied by every output builder) ──────
  # Insecure allowances, matched by name prefix so they survive version bumps:
  #  - librewolf: flagged insecure in nixpkgs (lacks an active committer).
  #  - pnpm: build-time dependency of vesktop; flagged for npm CVEs that don't
  #    apply to sandboxed nix builds with a fixed lockfile.
  nixpkgsConfig = {
    allowUnfree = true;
    allowInsecurePredicate = pkg:
      builtins.any
      (prefix: nixpkgs.lib.hasPrefix prefix (nixpkgs.lib.getName pkg))
      ["librewolf" "pnpm"];
  };

  # ── Shared nixpkgs overlays (applied by every output builder) ────
  # Per-output overlays are appended via `nixpkgsOverlays`.
  sharedOverlays = [
    (import (self + /overlays/lix.nix))
  ];

  # ── Shared modules (NixOS + nix-darwin) ──────────────────────────
  sharedModules = [
    (self + /modules/shared/options.nix)
    (self + /modules/shared/nix-settings.nix)
  ];

  # ── Shared system modules (included in every NixOS output) ───────
  sharedSystemModules =
    sharedModules
    ++ [
      (self + /modules/system/base.nix)
    ];

  # ── Shared Home Manager modules ──────────────────────────────────
  # Included for every home user unless the user opts out with
  # `withSharedHomeModules = false`. modules/shared/options.nix is always
  # imported first by mkHomeImports and is not listed here.
  sharedHomeModules = [
    (self + /modules/home/cli-base-apps.nix)
    (self + /modules/home/containers.nix)
    (self + /modules/home/fastfetch.nix)
    (self + /modules/home/nixvim)
  ];

  # ── Named home overlay groups (selected explicitly by outputs) ───
  homeOverlayGroups = {
    ai = [(self + /modules/home/ai.nix)];
  };

  # ── User definitions ─────────────────────────────────────────────
  users = {
    gars = {module = self + /modules/home/users/gars;};
    htmlgxn = {module = self + /modules/home/users/htmlgxn.nix;};
    janine = {module = self + /modules/home/users/janine.nix;};
  };

  # ── NixOS host definitions ────────────────────────────────────────
  hosts = {
    boreal = {
      system = "x86_64-linux";
      module = self + /hosts/boreal/configuration.nix;
      extraSystemModules = [
        (self + /modules/system/jellyfin.nix)
        (self + /modules/system/containers.nix)
      ];
      hostHomeModules = [
        (self + /hosts/boreal/home.nix)
        (self + /modules/home/packages)
      ];
    };

    nixos-vm = {
      system = "x86_64-linux";
      module = self + /hosts/nixos-vm/configuration.nix;
      hostHomeModules = [(self + /hosts/nixos-vm/home.nix)];
    };

    rpi4 = {
      system = "aarch64-linux";
      module = self + /hosts/rpi4/configuration.nix;
      extraSystemModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
      hostHomeModules = [(self + /hosts/rpi4/home.nix)];
    };

    jtop = {
      system = "x86_64-linux";
      module = self + /hosts/jtop/configuration.nix;
      extraSystemModules = [
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-ssd
      ];
      hostHomeModules = [(self + /hosts/jtop/home.nix)];
    };

    # cyberdeck = {
    #   system = "aarch64-linux";
    #   module = self + /hosts/cyberdeck/configuration.nix;
    #   extraSystemModules = [
    #     inputs.jetpack-nixos.nixosModules.default
    #   ];
    # };
  };

  # ── nix-darwin host definitions ───────────────────────────────────
  darwinHosts = {
    macbook = {
      system = "aarch64-darwin";
      module = self + /hosts/macbook/configuration.nix;
      hostHomeModules = [(self + /hosts/macbook/home.nix)];
    };
  };

  # ── Home Manager profiles ─────────────────────────────────────────
  # Each profile is a complete module list; the richer ones are built from
  # the leaner ones so a module is only ever named once.
  homeProfiles = rec {
    cli = [];

    gui = [
      (self + /modules/home/gui-base-apps.nix)
    ];

    gnome = [
      (self + /modules/home/gnome.nix)
      (self + /modules/home/gnome-theme.nix)
    ];

    cosmic = [
      (self + /modules/home/cosmic.nix)
      (self + /modules/home/cosmic-theme.nix)
    ];

    # Declarative sway config only, for hosts that use the host OS's sway
    # binaries (jetson).
    sway-config = [
      (self + /modules/home/sway.nix)
    ];

    sway =
      sway-config
      ++ [
        (self + /modules/home/sway-apps.nix)
      ];

    sway-full =
      sway
      ++ [
        (self + /modules/home/gui-extra-apps.nix)
        (self + /modules/home/flatpak.nix)
        (self + /modules/home/gaming.nix)
      ];
  };

  # ── NixOS system profiles ─────────────────────────────────────────
  systemProfiles = rec {
    tty = [
      (self + /modules/system/cli.nix)
      (self + /modules/system/nix-ld.nix)
    ];

    gnome = tty ++ [(self + /modules/system/gnome.nix)];

    cosmic = tty ++ [(self + /modules/system/cosmic.nix)];

    sway = tty ++ [(self + /modules/system/sway.nix)];

    sway-full =
      sway
      ++ [
        (self + /modules/system/flatpak.nix)
        (self + /modules/system/gaming.nix)
      ];
  };
in {
  _module.args.inventory = {
    inherit
      nixpkgsConfig
      sharedOverlays
      sharedModules
      sharedSystemModules
      sharedHomeModules
      homeOverlayGroups
      users
      hosts
      darwinHosts
      homeProfiles
      systemProfiles
      ;
  };
}
