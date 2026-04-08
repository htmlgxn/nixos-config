# nix-darwin system configuration for macOS Apple Silicon.
{pkgs, ...}: {
  # nix-darwin state version
  system.stateVersion = 5;
  system.primaryUser = "htmlgxn";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # ── macOS system preferences ───────────────────────────────────────
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      NSAutomaticWindowAnimationsEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    dock = {
      autohide = true;
      static-only = true;
      mru-spaces = false;
      tilesize = 32;
      magnification = false;
      launchanim = false;
      mineffect = "scale";
      persistent-apps = [
        "~/Applications/Home Manager Apps/Signal.app"
        "~/Applications/Home Manager Apps/Brave Browser.app"
        "~/Applications/Home Manager Apps/kitty.app"
        "~/Applications/Home Manager Apps/Spotify.app"
        "~/Applications/Home Manager Apps/Vesktop.app"
      ];
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv";
    };
  };

  # ── Homebrew integration (GUI apps not in nixpkgs) ─────────────────
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    casks = [
      "android-platform-tools"
      "cursor"
      "freecad"
      "protonvpn"
      "codex"
      "claude"
      "kicad"
      "jellyfin-media-player"
      "zoom"
      "background-music"
      "calibre"
      "steam"
      "orcaslicer"
      "font-symbols-only-nerd-font"
      "sol"
    ];
  };

  # ── Spotlight ───────────────────────────────────────────────────────
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys" = {
    AppleSymbolicHotKeys = {
      # 64 = Spotlight search, 65 = Finder search window
      "64" = {enabled = false;};
      "65" = {enabled = false;};
    };
  };

  # ── Security ───────────────────────────────────────────────────────
  # ── Shell ───────────────────────────────────────────────────────────
  environment.shells = with pkgs; [nushell bashInteractive];
  users.users.htmlgxn.shell = pkgs.nushell;

  security.pam.services.sudo_local.touchIdAuth = true;
}
