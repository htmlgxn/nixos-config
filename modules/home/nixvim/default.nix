# modules/home/nixvim/default.nix
{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    colorscheme = config.my.nvimTheme;

    extraFiles = {
      "colors/gars-yellow-dark.lua".source = ../themes/nvim/gars-yellow-dark.lua;
      "colors/gars-yellow-light.lua".source = ../themes/nvim/gars-yellow-light.lua;
    };
  };
}
