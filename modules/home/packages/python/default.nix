# Python toolchain and uv-managed tool set.
{
  config,
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
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      stdenv.cc.cc.lib
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
      # ── Libraries ────────────────────────────────────────────────────
      playwright-driver # Playwright CLI and Python package
      playwright-driver.browsers # Pre-built browsers for Playwright
    ];

  programs.bash.sessionVariables = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  programs.nushell.environmentVariables = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  # Tool venvs point at the Nix python store path, so reinstall everything only
  # when that path changes; otherwise just install tools that are missing.
  home.activation.installUvTools = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 (lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    uv=${pkgs.uv}/bin/uv
    python=${pkgs.python314}/bin/python3
    stamp="${config.xdg.stateHome}/uv-tools-python"

    force=""
    if [[ "$(cat "$stamp" 2>/dev/null)" != "$python" ]]; then
      force="--force"
    fi
    installed=$($uv tool list 2>/dev/null | ${pkgs.gawk}/bin/awk '/^[^ -]/ {print $1}')

    for tool in ${lib.concatStringsSep " " uvTools}; do
      if [[ -n "$force" ]] || ! grep -qxF "$tool" <<<"$installed"; then
        echo "uv: installing $tool..."
        run $uv tool install "$tool" $force --python "$python"
      fi
    done

    run mkdir -p "$(dirname "$stamp")"
    [[ -v DRY_RUN ]] || echo "$python" > "$stamp"
  '');
}
