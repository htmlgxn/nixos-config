# Minimal cage + kitty session for Jetson (L4T).
# Cage is a single-window Wayland compositor — runs kitty fullscreen from TTY.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./terminal-theme.nix
    ./kitty.nix
  ];

  my.terminal = "kitty";

  home.packages = [pkgs.cage];

  # Convenience script: `start-kitty` launches cage with kitty from a TTY
  home.file.".local/bin/start-kitty" = {
    executable = true;
    text = ''
      #!/bin/sh
      exec cage -- ${pkgs.kitty}/bin/kitty
    '';
  };
}
