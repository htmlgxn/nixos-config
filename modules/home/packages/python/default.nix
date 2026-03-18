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
#   - uv-managed tools from uv-tools.nix (or overridden via uvTools.packages)
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
# TO OVERRIDE UV TOOLS (e.g., for device-specific tools):
#   Set uvTools.packages = [ "tool1" "tool2" ]; in your module
#   This overrides uv-tools.nix for that specific configuration.
#
# SESSION VARIABLES:
#   PLAYWRIGHT_BROWSERS_PATH - Uses Nix-managed browsers
#   PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS - Skip env checks
# =============================================================================
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Allow overriding uvTools via config option (e.g., cli-cyberdeck.nix)
  uvTools = config.uvTools.packages or (import ./uv-tools.nix);
in {
  options.uvTools.packages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = null;
    description = "List of uv tools to install (overrides uv-tools.nix)";
  };

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
