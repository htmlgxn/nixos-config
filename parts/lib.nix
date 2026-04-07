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

  # ── Shared system modules (included in every NixOS output) ───────
  sharedSystemModules = [
    (self + /modules/shared/options.nix)
    (self + /modules/system/defaults.nix)
  ];

  # ── Named home overlay groups (selected explicitly by outputs) ───
  borealDesktopModule = _: {
    my.dualKeyboardLayout = true;
    my.showRootDisk = true;
    my.terminal = "kitty";
  };

  homeOverlayGroups = rec {
    ai-cli-orchestrators = [(self + /modules/home/ai-cli-orchestrators.nix)];
    ai-cli-extras = [(self + /modules/home/ai-cli-extras.nix)];
    ai-cli-agents = [(self + /modules/home/ai-cli-agents.nix)];
    ai-cli-all = ai-cli-orchestrators ++ ai-cli-agents ++ ai-cli-extras;
    ai-ollama = [(self + /modules/home/ai-ollama.nix)];
    ai-ollama-rocm = ai-ollama ++ [(self + /modules/home/ai-ollama-rocm.nix)];
    cli-extras = [(self + /modules/home/cli-extras.nix)];
    boreal-gui = ai-cli-all ++ ai-ollama-rocm ++ [(self + /modules/home/brave-bookmarks-sync.nix)];
    boreal-desktop = [borealDesktopModule];
  };

  # ── Shared Home Manager modules (included in every HM output) ────
  sharedHomeModules = [
    (self + /modules/shared/options.nix)
    (self + /modules/home/cli.nix)
    (self + /modules/home/containers.nix)
    (self + /modules/home/fastfetch.nix)
    (self + /modules/home/packages)
    (self + /modules/home/nixvim)
  ];

  # ── User definitions ─────────────────────────────────────────────
  users = {
    gars = {module = self + /modules/home/users/gars.nix;};
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
      hostHomeModules = [(self + /hosts/boreal/home.nix)];
    };

    nixos-vm = {
      system = "x86_64-linux";
      module = self + /hosts/nixos-vm/configuration.nix;
      extraSystemModules = [];
    };

    rpi4 = {
      system = "aarch64-linux";
      module = self + /hosts/rpi4/configuration.nix;
      extraSystemModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
    };

    # cyberdeck = {
    #   system = "aarch64-linux";
    #   module = self + /hosts/cyberdeck/configuration.nix;
    #   extraSystemModules = [
    #     jetpack-nixos.nixosModules.default
    #   ];
    # };
  };

  # ── Home Manager profiles ─────────────────────────────────────────
  homeProfiles = {
    cli = [];

    sway = [
      (self + /modules/home/gui-base.nix)
      (self + /modules/home/gui-extras.nix)
      (self + /modules/home/sway.nix)
      (self + /modules/home/flatpak.nix)
      (self + /modules/home/gaming.nix)
    ];

    sway-arm = [
      (self + /modules/home/gui-base.nix)
      (self + /modules/home/sway.nix)
    ];
  };

  # ── NixOS system profiles ─────────────────────────────────────────
  systemProfiles = {
    tty = [
      (self + /modules/system/cli.nix)
    ];

    sway = [
      (self + /modules/system/cli.nix)
      (self + /modules/system/sway.nix)
      (self + /modules/system/flatpak.nix)
      (self + /modules/system/gaming.nix)
    ];

    sway-arm = [
      (self + /modules/system/cli.nix)
      (self + /modules/system/sway.nix)
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

  # ── Builder: NixOS Home Manager sub-module ────────────────────────
  mkHomeModule = {
    userName,
    homeProfile,
    hostHomeModules ? [],
    homeOverlays ? [],
  }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "bak";
    home-manager.extraSpecialArgs = {inherit inputs;};
    home-manager.users.${userName} = {
      imports = mkHomeImports {inherit userName homeProfile hostHomeModules homeOverlays;};
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
      modules =
        sharedSystemModules
        ++ [
          (_: {
            nixpkgs.hostPlatform = host.system;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = nixpkgsOverlays;
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
          })
        ];
    };

  # ── Builder: nix-darwin output ────────────────────────────────────
  mkDarwinOutput = {
    userName,
    homeProfile,
    system,
    homeOverlays ? [],
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        (self + /hosts/macbook/configuration.nix)
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.${userName} = {
            imports = mkHomeImports {inherit userName homeProfile homeOverlays;};
          };
        }
      ];
    };

  # ── Builder: standalone Home Manager output ───────────────────────
  mkHomeOutput = {
    userName,
    homeProfile,
    system,
    hostHomeModules ? [],
    homeOverlays ? [],
  }: let
    pkgs = nixpkgs.legacyPackages.${system};
  in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules =
        mkHomeImports {inherit userName homeProfile hostHomeModules homeOverlays;}
        ++ [
          {
            home.username = userName;
            home.homeDirectory = "/home/${userName}";
            home.stateVersion = "26.05";
          }
        ];
    };
in {
  # Expose builder functions to all other parts modules.
  _module.args.flakeLib = {inherit mkOutput mkDarwinOutput mkHomeOutput;};
}
