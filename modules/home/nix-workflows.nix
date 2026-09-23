# Nix workflow helpers (nr, nrb, ncheck, nboh, ...) packaged as the `nixcfg`
# CLI from scripts/nixcfg.sh, so they work from any shell. Each subcommand is
# also aliased by name via my.shellAliases (bash + nushell).
{
  config,
  lib,
  pkgs,
  ...
}: let
  script = ../../scripts/nixcfg.sh;

  nixcfg = pkgs.writeShellApplication {
    name = "nixcfg";
    # The helpers were written for an interactive shell: they test "$1" without
    # defaults and handle failures with `|| return 1`, so keep bash defaults.
    bashOptions = [];
    # Subcommands are dispatched by name at runtime, which shellcheck can't see.
    excludeShellChecks = ["SC2329"];
    runtimeEnv = {
      NIXCFG_REPO = config.my.repoRoot;
      NIXCFG_CONTAINERS = config.my.containersRoot;
    };
    text = builtins.readFile script;
  };

  # Public subcommands, read from the dispatcher table in the script.
  commands = let
    line = lib.findFirst (lib.hasPrefix "_nixcfg_commands=(") "" (lib.splitString "\n" (builtins.readFile script));
  in
    lib.filter (c: c != "") (lib.splitString " " (lib.removeSuffix ")" (lib.removePrefix "_nixcfg_commands=(" line)));
in {
  home.packages = [nixcfg];

  my.shellAliases =
    lib.genAttrs commands (cmd: "nixcfg ${cmd}")
    // {
      nflk = "nvim ${config.my.repoRoot}/flake.nix";
      nfmt = "nixcfg fnix";
    };
}
