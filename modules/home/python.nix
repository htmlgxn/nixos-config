#
# ~/nixos-config/modules/home/python.nix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    python314
    uv # Python package/toolchain manager
    stdenv.cc.cc.lib # Runtime dependency for native Python packages (scrapling, etc.)
    playwright-driver # Playwright CLI and Python package
    playwright-driver.browsers # Pre-built browsers for Playwright
  ];

  # Session variables for Python/Playwright
  # Using programs.bash.sessionVariables to match home.nix pattern
  programs.bash.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
