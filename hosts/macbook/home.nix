# macbook-specific home-manager configuration.
# Included automatically for every macbook output via hostHomeModules.
{
  config,
  lib,
  pkgs,
  ...
}: let
  hmAppsDir = "${config.home.homeDirectory}/${config.targets.darwin.copyApps.directory}";
  lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
in {
  home.packages = with pkgs; [yt-dlp];

  # Go binaries from `go install ...@latest` land in ~/go/bin. The `go` compiler
  # itself is installed via Homebrew (see configuration.nix). This keeps Go fully
  # imperative on the macbook, matching the rustup/uv setup — no Nix-managed Go.
  home.sessionPath = ["$HOME/go/bin"];
  imports = [
    ../../modules/home/kitty.nix
    ../../modules/home/terminal-theme.nix
  ];

  my = {
    terminal = "kitty";
    terminalFontSize = 14.0;
    # ollama 0.30.x requires Xcode's Metal toolchain to build on darwin, so the
    # Nix package is skipped; the Homebrew cask in configuration.nix provides it.
    ollamaPackage = null;
  };
  # macOS nushell looks in ~/Library/Application Support/nushell/ by default.
  # Symlink it to the XDG path so HM-managed config is picked up.
  home.file."Library/Application Support/nushell".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nushell";

  # nix-darwin injects PATH via /etc/zshenv and /etc/bashrc, which nushell
  # doesn't source.  Add the nix profile paths explicitly.
  # Each `prepend` lands in front of the previous one, so the last Nix entry
  # wins: per-user > system > the installer's default profile (whose nix is
  # the Lix the installer shipped, not the one nix-darwin manages).
  programs.nushell.extraEnv = ''
    $env.PATH = ($env.PATH
      | prepend "/nix/var/nix/profiles/default/bin"
      | prepend "/run/current-system/sw/bin"
      | prepend "/etc/profiles/per-user/${config.home.username}/bin"
      | prepend "/opt/homebrew/bin"
      | prepend ($env.HOME | path join ".cargo" "bin")
      | prepend ($env.HOME | path join "go" "bin")
    )
  '';

  my.shellAliases.nrs = "nh darwin switch ${config.my.repoRoot} -H macbook";

  # LaunchServices remembers every .app bundle it has ever seen, including ones
  # inside /nix/store from old generations or ad-hoc builds. Several bundles
  # sharing one bundle id (e.g. an unpatched kitty) make Spotlight/Dock/`open -a`
  # launch an arbitrary one, so after each switch drop registrations for store
  # bundles outside the new generation (AeroSpace itself runs from the store).
  home.activation.lsUnregisterNixStoreApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
    live=$(/run/current-system/sw/bin/nix-store -qR "$newGenPath" 2>/dev/null || true)
    ${lsregister} -dump 2>/dev/null \
      | sed -n 's|^path: *\(/nix/store/[^/]*/.*\.app\) (0x[0-9a-f]*)$|\1|p' \
      | sort -u \
      | while IFS= read -r app; do
          storePath=$(echo "$app" | cut -d/ -f1-4)
          if ! grep -qxF "$storePath" <<<"$live"; then
            run ${lsregister} -u "$app" || true
          fi
        done
  '';

  # ── AeroSpace tiling window manager ──────────────────────────────────
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      config-version = 2;

      after-startup-command = ["layout tiling"];

      # v1 inferred these from the alt-1..9 bindings; v2 requires them explicit
      persistent-workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];

      gaps = {
        outer.left = 8;
        outer.right = 8;
        outer.top = 8;
        outer.bottom = 8;
        inner.horizontal = 8;
        inner.vertical = 8;
      };

      mode.main.binding = {
        # ── Focus (matches sway Mod+hjkl) ────────────────────────────
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # ── Move (matches sway Mod+Shift+hjkl) ──────────────────────
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # ── Layout ───────────────────────────────────────────────────
        alt-f = "fullscreen";
        alt-shift-space = "layout floating tiling";
        alt-e = "layout tiles horizontal vertical";
        alt-s = "layout accordion";

        # ── Workspaces (matches sway Mod+1-9) ────────────────────────
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        # ── Move to workspace ────────────────────────────────────────
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";

        # ── Workspace navigation ─────────────────────────────────────
        alt-period = "workspace next";
        alt-comma = "workspace prev";

        # ── Window management ────────────────────────────────────────
        alt-q = "close";
        alt-shift-c = "reload-config";
        # Launch the HM Apps copy by path: `open -a kitty` lets LaunchServices
        # pick any registered bundle with kitty's id, including stale unpatched
        # ones in /nix/store (see overlays/kitty-launchservices.nix).
        alt-enter = "exec-and-forget open -a '${hmAppsDir}/kitty.app'";

        # ── Resize mode ──────────────────────────────────────────────
        alt-r = "mode resize";
      };

      mode.resize.binding = {
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";
        esc = "mode main";
        enter = "mode main";
      };
    };
  };

  # ── macOS per-app defaults (like `defaults write` but declarative) ──
  targets.darwin.defaults = {
    "com.apple.finder".DisableAllAnimations = true;
  };

  # ── macOS Cocoa keybindings (system-wide text input shortcuts) ─────
  targets.darwin.keybindings = {
    # Move by word with option+arrow
    "~f" = "moveWordForward:";
    "~b" = "moveWordBackward:";
    # Delete word backward with option+backspace
    "~d" = "deleteWordForward:";
  };

  # ── macOS SSH entries ────────────────────────────────────────────────
  programs.ssh.settings."github.com" = {
    hostname = "github.com";
    AddKeysToAgent = "yes";
    UseKeychain = "yes";
    identityFile = "~/.ssh/id_ed25519";
  };
}
