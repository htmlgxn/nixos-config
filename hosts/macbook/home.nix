# macbook-specific home-manager configuration.
# Included automatically for every macbook output via hostHomeModules.
{config, ...}: {
  imports = [
    ../../modules/home/kitty.nix
    ../../modules/home/terminal-theme.nix
  ];

  my = {
    terminal = "kitty";
    terminalFontSize = 14.0;
  };
  # macOS nushell looks in ~/Library/Application Support/nushell/ by default.
  # Symlink it to the XDG path so HM-managed config is picked up.
  home.file."Library/Application Support/nushell".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nushell";

  # nix-darwin injects PATH via /etc/zshenv and /etc/bashrc, which nushell
  # doesn't source.  Add the nix profile paths explicitly.
  programs.nushell.extraEnv = ''
    $env.PATH = ($env.PATH
      | prepend "/etc/profiles/per-user/${config.home.username}/bin"
      | prepend "/run/current-system/sw/bin"
      | prepend "/nix/var/nix/profiles/default/bin"
    )
  '';

  programs.bash.shellAliases.nrs = "nh darwin switch ${config.my.repoRoot} -H macbook";
  programs.nushell.shellAliases.nrs = "nh darwin switch ${config.my.repoRoot} -H macbook";

  # ── AeroSpace tiling window manager ──────────────────────────────────
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      after-startup-command = ["layout tiling"];

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
        alt-enter = "exec-and-forget open -a kitty";

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
  programs.ssh.matchBlocks."github.com" = {
    hostname = "github.com";
    extraOptions = {
      AddKeysToAgent = "yes";
      UseKeychain = "yes";
    };
    identityFile = "~/.ssh/id_ed25519";
  };
}
