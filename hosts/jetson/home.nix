{...}: {
  targets.genericLinux.enable = true;
  home.sessionVariables = {
    CUDA_PATH = "/usr/local/cuda";
    LD_LIBRARY_PATH = "/usr/local/cuda/lib64:/usr/lib/aarch64-linux-gnu";
  };
}
