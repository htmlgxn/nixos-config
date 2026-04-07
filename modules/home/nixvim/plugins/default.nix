# modules/home/nixvim/plugins/default.nix
#
# Explicit plugin manifest. No auto-discovery — comment out entries
# to debug, add new modules here as they're introduced.
#
{...}: {
  imports = [
    ./alpha.nix
    ./completion.nix
    ./editor.nix
    ./fzf.nix
    ./oil.nix
    ./git.nix
    ./lsp.nix
    ./treesitter.nix
    ./ui.nix
  ];
}
