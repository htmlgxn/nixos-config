# parts/checks.nix
#
# `nix flake check` builds every host: each NixOS, nix-darwin and standalone
# Home Manager output is exposed as checks.<system>.<kind>-<name>, so a check
# run on any machine covers all outputs for that machine's platform.
{
  lib,
  self,
  ...
}: let
  collect = kind: configs: toplevel:
    lib.mapAttrsToList (name: cfg: {
      system = cfg.pkgs.stdenv.hostPlatform.system;
      name = "${kind}-${name}";
      value = toplevel cfg;
    })
    configs;

  all =
    collect "nixos" self.nixosConfigurations (cfg: cfg.config.system.build.toplevel)
    ++ collect "darwin" self.darwinConfigurations (cfg: cfg.system)
    ++ collect "home" self.homeConfigurations (cfg: cfg.activationPackage);
in {
  flake.checks =
    lib.mapAttrs (_: entries: lib.listToAttrs entries)
    (lib.groupBy (e: e.system) all);
}
