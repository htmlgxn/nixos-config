#
# ~/nixos-config/flake.nix
#
# Configuration Hierarchy:
#   TTY  → cli.nix + cli-extras.nix (+ optional cli-*.nix)
#   GUI  → TTY + gui-base.nix + <compositor>.nix + flatpak.nix
#
# NixOS Configurations:
#   boreal-tty         - TTY-only on boreal hardware
#   boreal-tty-cyberdeck - TTY + cyberdeck packages (testing on boreal)
#   boreal             - GUI (Sway) - production
#   boreal-niri        - GUI (Niri)
#   boreal-hypr        - GUI (Hyprland)
#   nixos-vm           - TTY-only VM
#   cyberdeck          - (future) TTY-only on aarch64 hardware
#
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bookokrat.url = "github:bugzmanov/bookokrat";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    # ── Home Manager Base ────────────────────────────────────────────────
    hmCommonImports = [
      ./home/gars/home.nix
      ./modules/home/cli.nix
      # Language toolchains & custom packages
      ./modules/home/packages
    ];

    mkHm = extraImports: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.users.gars = {
        imports = hmCommonImports ++ extraImports;
      };
    };

    # ── Home Manager: CLI Base ──────────────────────────────────────────
    hmCLI = mkHm [];

    hmCLIExtras = mkHm [
      ./modules/home/cli-extras.nix
    ];

    hmCLI_Cyberdeck = mkHm [
      ./modules/home/cli-cyberdeck.nix
    ];

    # ── Home Manager: GUI (extends CLI) ─────────────────────────────────
    hmGUI_Sway = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/sway.nix
      ./modules/home/flatpak.nix
    ];

    hmGUI_Niri = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/niri.nix
      ./modules/home/flatpak.nix
    ];

    hmGUI_Hyprland = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/hyprland.nix
      ./modules/home/flatpak.nix
    ];

    # ── NixOS: Helper Functions (x86_64) ─────────────────────────────────
    mkTTY_x86 = host: extraHmModules: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({...}: {
          nixpkgs.config.allowUnfree = true;
        })
        ./hosts/${host}/configuration.nix
        ./modules/system/cli.nix
        ./modules/system/jellyfin.nix
        home-manager.nixosModules.home-manager
        hmCLI
        extraHmModules
        hmCLIExtras
      ];
    };

    mkGUI_x86 = host: compositor: extraHmModules: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({...}: {
          nixpkgs.config.allowUnfree = true;
        })
        ./hosts/${host}/configuration.nix
        ./modules/system/cli.nix
        ./modules/system/${compositor}.nix
        ./modules/system/flatpak.nix
        ./modules/system/jellyfin.nix
        home-manager.nixosModules.home-manager
        (mkHm [
          ./modules/home/gui-base.nix
          ./modules/home/${compositor}.nix
          ./modules/home/flatpak.nix
        ] ++ extraHmModules)
        hmCLIExtras
      ];
    };

    # ── NixOS: Helper Functions (aarch64) ────────────────────────────────
    mkTTY_aarch64 = host: extraHmModules: nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ({...}: {
          nixpkgs.config.allowUnfree = true;
        })
        ./hosts/${host}/configuration.nix
        ./modules/system/cli.nix
        home-manager.nixosModules.home-manager
        hmCLI
        extraHmModules
        # hmCLIExtras: enable only after the first successful build.
      ];
    };
  in {
    nixosConfigurations = {
      # ── TTY Only (x86_64) ──────────────────────────────────────────────
      boreal-tty = mkTTY_x86 "boreal" [];

      boreal-tty-cyberdeck = mkTTY_x86 "boreal" [
        ./modules/home/cli-cyberdeck.nix
      ];

      nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/nixos-vm/configuration.nix
          ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
          hmCLI
          # hmCLIExtras (disabled: VM minimal config)
        ];
      };

      # ── GUI (x86_64) ───────────────────────────────────────────────────
      boreal = mkGUI_x86 "boreal" "sway" [];

      boreal-niri = mkGUI_x86 "boreal" "niri" [];

      boreal-hypr = mkGUI_x86 "boreal" "hyprland" [];

      # ── Future (aarch64) ───────────────────────────────────────────────
      # cyberdeck = mkTTY_aarch64 "cyberdeck" [];
    };
  };
}
