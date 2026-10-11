# Shell layer shared by every interactive user: aliases (my.shellAliases,
# mirrored into bash and nushell), bash, nushell, starship and the nixcfg CLI.
{
  imports = [
    ./shell-aliases.nix
    ./nix-workflows.nix
    ./bash.nix
    ./nushell.nix
    ./starship.nix
  ];
}
