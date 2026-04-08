# jetson-specific home-manager configuration.
# Included automatically for every jetson output via hostHomeModules.
# The Jetson runs Ubuntu with proprietary NVIDIA/CUDA tooling — nix only
# layers on shell, CLI tools, and WM.  Dev toolchains (cargo, nvm, etc.)
# are managed by the host OS.
{config, ...}: {
  targets.genericLinux.enable = true;

  home.sessionVariables = {
    CUDA_PATH = "/usr/local/cuda";
    LD_LIBRARY_PATH = "/usr/local/cuda/lib64:/usr/lib/aarch64-linux-gnu";
  };

  # Preserve host-managed dev toolchains and CUDA in PATH
  programs.bash.initExtra = ''
    export PATH="/usr/local/cuda/bin:$PATH"
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  '';

  # Equivalent PATH setup for nushell (can't source bash scripts)
  programs.nushell.extraEnv = ''
    $env.PATH = ($env.PATH
      | prepend "/usr/local/cuda/bin"
      | prepend ($env.HOME | path join ".cargo" "bin")
      | prepend (glob ($env.HOME | path join ".nvm" "versions" "node" "*" "bin") | first)
    )
  '';

  programs.bash.shellAliases.nrs = "nh home switch -b bak ${config.my.repoRoot} -c jetson";
  programs.nushell.shellAliases.nrs = "nh home switch -b bak ${config.my.repoRoot} -c jetson";
}
