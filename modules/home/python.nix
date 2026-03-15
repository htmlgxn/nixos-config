#
# ~/nixos-config/modules/home/python.nix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    python314
    uv # Python package/toolchain manager
    stdenv.cc.cc.lib # Runtime dependency for native Python packages (scrapling, etc.)
    playwright-driver # Playwright with NixOS-compatible browsers
  ];

  # Set PLAYWRIGHT_BROWSERS_PATH to use nixpkgs-provided browsers
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
  };
}
