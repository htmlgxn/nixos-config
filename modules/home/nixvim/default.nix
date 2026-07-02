# modules/home/nixvim/default.nix
{
  inputs,
  config,
  pkgs,
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
    # Build nixvim against its own pinned nixpkgs rather than the system one.
    # nixvim relies on recently-added `lib` features, so it ships a matching
    # nixpkgs pin; using it (instead of `follows`/the system pkgs) is the
    # upstream-recommended setup and silences the "nixpkgs.source default
    # affected by follows" warning.
    #
    # We import that nixpkgs ourselves and pass it via `nixpkgs.pkgs`. We must
    # NOT use `nixpkgs.source` here: in home-manager nixvim re-imports the
    # source with the *host* nixpkgs' already-elaborated `hostPlatform`. Feeding
    # a platform elaborated by one nixpkgs version into a different version's
    # stdenv bootstrap triggers a `runtimeShell`/`bashNonInteractive` infinite
    # recursion. Importing with a plain-string `system` lets this nixpkgs
    # elaborate the platform itself, avoiding the cross-version cycle.
    nixpkgs.pkgs = import inputs.nixvim.inputs.nixpkgs {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
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
