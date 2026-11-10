# parts/lib.nix
#
# Output builders. They turn the descriptors in parts/inventory.nix into
# NixOS, nix-darwin and standalone Home Manager configurations, and are
# exposed to the other parts modules through _module.args.flakeLib.
{
  inputs,
  inventory,
  self,
  ...
}: let
  inherit (inputs) nixpkgs home-manager nix-darwin;
  inherit (nixpkgs) lib;
  inherit
    (inventory)
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

  # ── Helper: nixpkgs instance for a NixOS / nix-darwin output ──────
  mkNixpkgsModule = {
    system,
    overlays ? [],
  }: {
    nixpkgs = {
      hostPlatform = system;
      config = nixpkgsConfig;
      overlays = sharedOverlays ++ overlays;
    };
  };

  # ── Helper: assemble the full home imports list for one user ──────
  mkHomeImports = {
    userName,
    homeProfile,
    hostHomeModules ? [],
    homeOverlays ? [],
    withSharedHomeModules ? true,
  }:
    [(self + /modules/shared/options.nix)]
    ++ lib.optionals withSharedHomeModules sharedHomeModules
    ++ [users.${userName}.module]
    ++ homeProfiles.${homeProfile}
    ++ hostHomeModules
    ++ lib.concatMap (name: homeOverlayGroups.${name}) homeOverlays;

  # ── Builder: Home Manager as a NixOS / nix-darwin module ──────────
  # `homeUsers` maps user names to mkHomeImports arguments (minus userName),
  # so an output's extra desktop users are wired exactly like its primary one.
  mkHomeModule = {
    homeUsers,
    extraHomeModules ? [],
  }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = {inherit inputs;};
      users =
        lib.mapAttrs (userName: spec: {
          imports = mkHomeImports (spec // {inherit userName;}) ++ extraHomeModules;
        })
        homeUsers;
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
    # Additional desktop users: name -> { homeProfile, hostHomeModules ? [],
    # homeOverlays ? [], withSharedHomeModules ? true }.
    extraHomeUsers ? {},
  }: let
    host = hosts.${hostName};
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules =
        sharedSystemModules
        ++ [
          (mkNixpkgsModule {
            inherit (host) system;
            overlays = nixpkgsOverlays;
          })
          host.module
        ]
        ++ systemProfiles.${systemProfile}
        ++ host.extraSystemModules or []
        ++ [
          home-manager.nixosModules.home-manager
          (mkHomeModule {
            homeUsers =
              {
                ${userName} = {
                  inherit homeProfile homeOverlays;
                  hostHomeModules = host.hostHomeModules or [];
                };
              }
              // extraHomeUsers;
            # The system-level nh clean (modules/system/base.nix) already
            # covers user profiles.
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
      modules =
        sharedModules
        ++ [
          (mkNixpkgsModule {
            inherit (host) system;
            overlays = nixpkgsOverlays;
          })
          host.module
          home-manager.darwinModules.home-manager
          (mkHomeModule {
            homeUsers.${userName} = {
              inherit homeProfile homeOverlays;
              hostHomeModules = host.hostHomeModules or [];
            };
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
