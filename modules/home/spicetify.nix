# Spicetify (Spotify with theming), shared by every GUI user.
# Spotify is only available on x86_64-linux, x86_64-darwin, and aarch64-darwin.
{
  pkgs,
  lib,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  supported = builtins.elem pkgs.stdenv.hostPlatform.system ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = lib.mkIf supported {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      shuffle
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
