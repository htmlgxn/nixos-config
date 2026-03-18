# boreal graphics and GPU-specific settings.
{pkgs, ...}: {
  # AMD RX 570 — load amdgpu early for proper modesetting
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.xkb.extraLayouts.graphite = {
    description = "Graphite";
    languages = ["eng"];
    symbolsFile = ../../modules/shared/xkb/graphite;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa.opencl
    ];
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    ROC_ENABLE_PRE_VEGA = "1";
    QT_QPA_PLATFORM = "xcb";
  };
}
