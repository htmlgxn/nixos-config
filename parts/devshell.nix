# parts/devshell.nix
#
# `nix develop` (or direnv with `use flake`): the tools for working on this
# repo without installing them into any profile. The formatter wrapper is the
# same one `nix fmt` and `nix flake check` use (parts/treefmt.nix).
_: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        config.treefmt.build.wrapper
        nixd
        nh
        nix-output-monitor
        nvd
        nix-tree
      ];
    };
  };
}
