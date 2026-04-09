# jetson-specific home-manager configuration.
# Included automatically for every jetson output via hostHomeModules.
# The Jetson runs Ubuntu with proprietary NVIDIA/CUDA tooling — nix only
# layers on shell, CLI tools, and WM.  Dev toolchains (cargo, nvm, etc.)
# are managed by the host OS.
{
  config,
  lib,
  ...
}: {
  targets.genericLinux.enable = true;
  my.terminal = "foot";

  # Use system-installed sway — nix version can't access Jetson's NVIDIA libraries.
  wayland.windowManager.sway.package = null;

  # catppuccin-cursors v2 uses lowercase dir names; on NixOS the system
  # profile resolves the title-case name, but generic-Linux needs the
  # exact directory name so the ~/.icons symlink isn't broken.
  home.pointerCursor.name = lib.mkForce "catppuccin-mocha-yellow-cursors";

  home.sessionVariables = {
    CUDA_PATH = "/usr/local/cuda";
    WLR_NO_HARDWARE_CURSORS = "1";
    XCURSOR_PATH = "${config.home.homeDirectory}/.nix-profile/share/icons:${config.home.homeDirectory}/.local/share/icons:/usr/share/icons";
  };

  # Preserve host-managed dev toolchains and CUDA in PATH
  programs.bash.initExtra = ''
    export PATH="$HOME/.local/bin:/snap/bin:/usr/local/cuda/bin:$PATH"
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  '';

  # Equivalent PATH setup for nushell (can't source bash scripts)
  # Also set env vars that hm-session-vars.sh provides for bash but nushell can't source.
  programs.nushell.extraEnv = ''
    $env.PATH = ($env.PATH
      | prepend ($env.HOME | path join ".nix-profile" "bin")
      | prepend "/nix/var/nix/profiles/default/bin"
      | prepend "/usr/local/cuda/bin"
      | prepend ($env.HOME | path join ".cargo" "bin")
      | prepend (glob ($env.HOME | path join ".nvm" "versions" "node" "*" "bin") | first)
      | prepend ($env.HOME | path join ".local" "bin")
      | prepend "/snap/bin"
    )
    $env.WLR_NO_HARDWARE_CURSORS = "1"
  '';

  programs.bash.shellAliases = {
    sway = "sway --unsupported-gpu";
    nrs = "nh home switch -b bak ${config.my.repoRoot} -c jetson";
  };

  programs.nushell.shellAliases = {
    sway = "sway --unsupported-gpu";
    nrs = "nh home switch -b bak ${config.my.repoRoot} -c jetson";
  };
}
