# jetson-specific home-manager configuration.
# Included automatically for every jetson output via hostHomeModules.
{config, ...}: {
  targets.genericLinux.enable = true;
  home.sessionVariables = {
    CUDA_PATH = "/usr/local/cuda";
    LD_LIBRARY_PATH = "/usr/local/cuda/lib64:/usr/lib/aarch64-linux-gnu";
    PATH = "/usr/local/cuda/bin:$PATH";
  };

  programs.bash.shellAliases.nrs = "nh home switch ${config.my.repoRoot} -c jetson";
  programs.nushell.shellAliases.nrs = "nh home switch ${config.my.repoRoot} -c jetson";
}
