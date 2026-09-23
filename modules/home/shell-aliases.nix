# Shell-agnostic aliases: everything in `my.shellAliases` is mirrored into
# both bash and nushell. Home Manager's own `home.shellAliases` does not reach
# nushell, hence this option. Only use it for aliases that are valid in both
# shells (plain command + args); shell-specific ones stay in bash.nix/nushell.nix.
{
  config,
  lib,
  ...
}: {
  options.my.shellAliases = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
    example = {gs = "git status";};
    description = "Aliases applied to both bash and nushell.";
  };

  config = {
    programs.bash.shellAliases = config.my.shellAliases;
    programs.nushell.shellAliases = config.my.shellAliases;
  };
}
