# Python toolchain and uv-managed tool set.
{
  config,
  pkgs,
  lib,
  ...
}: let
  uvTools = import ./uv-tools.nix;

  # uv uses its own CPython builds, never the Nix interpreter. Those are
  # ordinary FHS binaries, so native wheels get libstdc++ & co. from nix-ld
  # on NixOS (modules/system/nix-ld.nix) and from the host on Fedora/macOS,
  # without a session-wide LD_LIBRARY_PATH. Same minor as python314 below.
  uvPython = pkgs.python314.pythonVersion;
  uvEnv = {UV_MANAGED_PYTHON = "1";};

  playwrightEnv = lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
in {
  home.packages = with pkgs;
    [
      # ── Toolchain ────────────────────────────────────────────────────
      python314
      uv # Python package/toolchain manager
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
      # ── Libraries ────────────────────────────────────────────────────
      playwright-driver # Playwright CLI and Python package
      playwright-driver.browsers # Pre-built browsers for Playwright
    ];

  programs.bash.sessionVariables = uvEnv // playwrightEnv;
  programs.nushell.environmentVariables = uvEnv // playwrightEnv;

  # Tool venvs are tied to the interpreter they were built with. When the
  # stamp changes (first run after leaving the Nix python, or a new minor),
  # rebuild *every* installed tool -- including ones installed by hand -- on
  # uv-managed CPython; a tool that fails only warns so activation (which also
  # runs at boot, possibly offline) never aborts. Otherwise just install
  # missing tools from uv-tools.nix.
  home.activation.installUvTools = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 (lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    uv=${pkgs.uv}/bin/uv
    py=(--managed-python --python ${uvPython})
    # Older sessions exported UV_PYTHON_DOWNLOADS=never; standalone
    # `home-manager switch` would inherit it and refuse to fetch CPython.
    export UV_PYTHON_DOWNLOADS=automatic
    stamp="${config.xdg.stateHome}/uv-tools-python"
    want="uv-managed-${uvPython}"

    # One directory per tool, including broken envs that `uv tool list` skips.
    tooldir=$($uv tool dir)
    installed=$(cd "$tooldir" 2>/dev/null && for d in */; do [[ -e "$d" ]] && echo "''${d%/}"; done)

    if [[ "$(cat "$stamp" 2>/dev/null)" != "$want" ]]; then
      ok=1
      for tool in $installed; do
        echo "uv: rebuilding $tool on CPython ${uvPython} (uv-managed)..."
        # upgrade keeps the original install spec (git URL, extras, ...);
        # install is the fallback for envs too broken to upgrade.
        run $uv tool upgrade "$tool" --reinstall "''${py[@]}" \
          || run $uv tool install "$tool" --reinstall "''${py[@]}" \
          || { ok=; warnEcho "uv: failed to rebuild $tool; run: uv tool install $tool --reinstall"; }
      done
      if [[ -n "$ok" ]]; then
        run mkdir -p "$(dirname "$stamp")"
        [[ -v DRY_RUN ]] || echo "$want" > "$stamp"
      fi
    fi

    for tool in ${lib.concatStringsSep " " uvTools}; do
      if ! grep -qxF "$tool" <<<"$installed"; then
        echo "uv: installing $tool..."
        run $uv tool install "$tool" "''${py[@]}" \
          || warnEcho "uv: failed to install $tool"
      fi
    done
  '');
}
