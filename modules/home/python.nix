#
# ~/nixos-config/modules/home/python.nix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    python314
    uv # Python package/toolchain manager
    stdenv.cc.cc.lib # Runtime dependency for native Python packages (scrapling, etc.)
    playwright-driver.browsers # Pre-built browsers for Playwright
  ];

  # Environment variables for Playwright
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
