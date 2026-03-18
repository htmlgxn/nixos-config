#
# ~/nixos-config/modules/home/packages/python/default.nix
#
# =============================================================================
# PYTHON TOOLCHAIN & TOOLS
# =============================================================================
# Python programming language toolchain and uv-managed tools.
#
# Includes:
#   - Python 3.14 interpreter
#   - uv (fast Python package/toolchain manager)
#   - Standard libraries (cc.lib for native packages)
#   - Playwright (browser automation)
#   - uv-managed tools from uv-tools.nix
#
# TO ADD PYTHON PACKAGES:
#
# Option 1 - From nixpkgs:
#   home.packages = with pkgs; [ python314Packages.requests ];
#
# Option 2 - Using uv (recommended for latest versions):
#   1. Add to uv-tools.nix: "package-name"
#   2. Install: uv tool install package-name
#
# TO ADD UV TOOLS:
#   1. Add to uv-tools.nix: "ruff" "mypy" etc.
#   2. Tools are auto-installed on rebuild
#
# SESSION VARIABLES:
#   PLAYWRIGHT_BROWSERS_PATH - Uses Nix-managed browsers
#   PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS - Skip env checks
# =============================================================================
#
{
  pkgs,
  lib,
  ...
}: let
  uvTools = import ./uv-tools.nix;
in {
  home.packages = with pkgs; [
    # ── Toolchain ────────────────────────────────────────────────────
    python314
    uv # Python package/toolchain manager

    # ── Libraries ────────────────────────────────────────────────────
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

  home.activation.installUvTools = lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    for tool in ${lib.concatStringsSep " " uvTools}; do
      echo "uv: (re)installing $tool..."
      ${pkgs.uv}/bin/uv tool install "$tool" --force \
        --python ${pkgs.python314}/bin/python3
    done
  '';
}
