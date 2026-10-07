# parts/lib.nix
#
# Shared profiles, users, hosts, overlay groups, and output builder functions.
# Everything is captured in plain Nix let-bindings and exposed to the other
# parts modules through _module.args.flakeLib so they stay independent files
# with a clear, named contract instead of one monolithic outputs block.
{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs home-manager nix-darwin nixos-hardware;
  inherit (nixpkgs) lib;

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

  # ── Shared system modules (included in every NixOS output) ───────
  sharedSystemModules = [
    (self + /modules/shared/options.nix)
    (self + /modules/shared/nix-settings.nix)
    ({
      pkgs,
      config,
      ...
    }: {
      time.timeZone = "America/Halifax";
      i18n.defaultLocale = "en_CA.UTF-8";
      documentation.nixos.enable = false;
      users.users.${config.my.primaryUser}.shell = pkgs.nushell;
      environment.shells = with pkgs; [nushell bashInteractive];

      # System-level nh: `nh clean all` also prunes system generations, which
      # the Home Manager `nh clean user` timer never touches (see mkHomeModule).
      programs.nh = {
        enable = true;
        flake = "/home/${config.my.primaryUser}/nixos-config";
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep 3";
        };
      };
    })
  ];

  # ── Named home overlay groups (selected explicitly by outputs) ───
  homeOverlayGroups = {
    ai = [(self + /modules/home/ai.nix)];
  };

  # ── Shared Home Manager modules (included in every HM output) ────
  sharedHomeModules = [
    (self + /modules/shared/options.nix)
    (self + /modules/home/cli-base-apps.nix)
    (self + /modules/home/containers.nix)
    (self + /modules/home/fastfetch.nix)
    (self + /modules/home/nixvim)
  ];

  # ── User definitions ─────────────────────────────────────────────
  users = {
    gars = {module = self + /modules/home/users/gars;};
    htmlgxn = {module = self + /modules/home/users/htmlgxn.nix;};
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
      extraSystemModules = [];
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

    # cyberdeck = {
    #   system = "aarch64-linux";
    #   module = self + /hosts/cyberdeck/configuration.nix;
    #   extraSystemModules = [
    #     jetpack-nixos.nixosModules.default
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
  homeProfiles = {
    cli = [];

    gui = [
      (self + /modules/home/gui-base-apps.nix)
    ];

    sway-config = [
      (self + /modules/home/sway.nix)
    ];

    sway = [
      (self + /modules/home/sway.nix)
      (self + /modules/home/sway-apps.nix)
    ];

    sway-full = [
      (self + /modules/home/sway.nix)
      (self + /modules/home/sway-apps.nix)
      (self + /modules/home/gui-extra-apps.nix)
      (self + /modules/home/flatpak.nix)
      (self + /modules/home/gaming.nix)
    ];
  };

  # ── NixOS system profiles ─────────────────────────────────────────
  systemProfiles = {
    tty = [
      (self + /modules/system/cli.nix)
      (self + /modules/system/nix-ld.nix)
    ];

    sway = [
      (self + /modules/system/cli.nix)
      (self + /modules/system/nix-ld.nix)
      (self + /modules/system/sway.nix)
    ];

    sway-full = [
      (self + /modules/system/cli.nix)
      (self + /modules/system/nix-ld.nix)
      (self + /modules/system/sway.nix)
      (self + /modules/system/flatpak.nix)
      (self + /modules/system/gaming.nix)
    ];
  };

  # ── Helper: resolve overlay names to module lists ─────────────────
  resolveHomeOverlays = overlayNames:
    builtins.concatLists (map (name: homeOverlayGroups.${name}) overlayNames);

  # ── Helper: assemble the full home imports list ───────────────────
  mkHomeImports = {
    userName,
    homeProfile,
    hostHomeModules ? [],
    homeOverlays ? [],
  }: let
    user = users.${userName};
  in
    sharedHomeModules
    ++ [user.module]
    ++ homeProfiles.${homeProfile}
    ++ hostHomeModules
    ++ resolveHomeOverlays homeOverlays;

  # ── Builder: Home Manager as a NixOS / nix-darwin module ──────────
  mkHomeModule = {
    userName,
    homeProfile,
    hostHomeModules ? [],
    homeOverlays ? [],
    extraHomeModules ? [],
  }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = {inherit inputs;};
      users.${userName}.imports =
        mkHomeImports {inherit userName homeProfile hostHomeModules homeOverlays;}
        ++ extraHomeModules;
    };
  };

  # ── Builder: NixOS output ─────────────────────────────────────────
  mkOutput = {
    hostName,
    userName,
    systemProfile,
    homeProfile,
    homeOverlays ? [],
    nixpkgsOverlays ? [],
  }: let
    host = hosts.${hostName};
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules =
        sharedSystemModules
        ++ [
          (_: {
            nixpkgs = {
              hostPlatform = host.system;
              config = nixpkgsConfig;
              overlays = sharedOverlays ++ nixpkgsOverlays;
            };
          })
          host.module
        ]
        ++ systemProfiles.${systemProfile}
        ++ host.extraSystemModules
        ++ [
          home-manager.nixosModules.home-manager
          (mkHomeModule {
            inherit userName homeProfile homeOverlays;
            hostHomeModules = host.hostHomeModules or [];
            # The system-level nh clean (sharedSystemModules) already covers user profiles.
            extraHomeModules = [{programs.nh.clean.enable = lib.mkForce false;}];
          })
        ];
    };

  # ── Builder: nix-darwin output ────────────────────────────────────
  mkDarwinOutput = {
    hostName,
    userName,
    homeProfile,
    homeOverlays ? [],
    nixpkgsOverlays ? [],
  }: let
    host = darwinHosts.${hostName};
  in
    nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        (self + /modules/shared/options.nix)
        (self + /modules/shared/nix-settings.nix)
        {
          nixpkgs = {
            hostPlatform = host.system;
            config = nixpkgsConfig;
            overlays = sharedOverlays ++ nixpkgsOverlays;
          };
        }
        host.module
        home-manager.darwinModules.home-manager
        (mkHomeModule {
          inherit userName homeProfile homeOverlays;
          hostHomeModules = host.hostHomeModules or [];
        })
      ];
    };

  # ── Builder: standalone Home Manager output ───────────────────────
  mkHomeOutput = {
    userName,
    homeProfile,
    system,
    hostHomeModules ? [],
    homeOverlays ? [],
  }:
    home-manager.lib.homeManagerConfiguration {
      # Configure nixpkgs once here; setting nixpkgs.config inside the HM
      # modules would make Home Manager re-import nixpkgs a second time.
      pkgs = import nixpkgs {
        inherit system;
        config = nixpkgsConfig;
        overlays = sharedOverlays;
      };
      extraSpecialArgs = {inherit inputs;};
      modules = mkHomeImports {inherit userName homeProfile hostHomeModules homeOverlays;};
    };
in {
  # Expose builder functions to all other parts modules.
  _module.args.flakeLib = {inherit mkOutput mkDarwinOutput mkHomeOutput;};
}
