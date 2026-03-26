# Python toolchain and uv-managed tool set.
{
  pkgs,
  lib,
  ...
}: let
  uvTools = import ./uv-tools.nix;
in {
  home.packages = with pkgs;
    [
      # ── Toolchain ────────────────────────────────────────────────────
      python314
      uv # Python package/toolchain manager
    ]
    # GCC runtime lib for native Python packages -- Linux only
    ++ lib.optionals pkgs.stdenv.isLinux [
      stdenv.cc.cc.lib
    ]
    ++ lib.optionals pkgs.stdenv.isx86_64 [
      # ── Libraries ────────────────────────────────────────────────────
      playwright-driver # Playwright CLI and Python package
      playwright-driver.browsers # Pre-built browsers for Playwright
    ];

  programs.bash.sessionVariables = lib.mkIf pkgs.stdenv.isx86_64 {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  home.activation.installUvTools = lib.mkIf pkgs.stdenv.isx86_64 (lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    for tool in ${lib.concatStringsSep " " uvTools}; do
      echo "uv: (re)installing $tool..."
      ${pkgs.uv}/bin/uv tool install "$tool" --force \
        --python ${pkgs.python314}/bin/python3
    done
  '');
}
