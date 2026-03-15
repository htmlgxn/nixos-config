#
# ~/nixos-config/modules/home/python.nix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    python314
    uv # Python package/toolchain manager
    stdenv.cc.cc.lib # Runtime dependency for native Python packages (scrapling, etc.)
  ];

  home.sessionVariables = {
    UV_PYTHON_DOWNLOADS = "never";
  };
}
