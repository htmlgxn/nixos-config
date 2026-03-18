# Python toolchain and uv-managed tool set.
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
