# nix-darwin system configuration for macOS Apple Silicon.
_: {
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
      autohide = false;
      static-only = true;
      mru-spaces = false;
      tilesize = 48;
      magnification = false;
      launchanim = false;
      mineffect = "scale";
      persistent-apps = [
        "/Applications/Brave Browser.app"
        "/Applications/kitty.app"
        "/Applications/Signal.app"
        "/System/Applications/Messages.app"
        "/Applications/Adobe Photoshop 2025/Adobe Photoshop 2025.app"
        "/Applications/DaVinci Resolve/DaVinci Resolve.app"
        "/Applications/qBittorrent.app"
        "/Applications/Spotify.app"
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
    casks = [
      "alacritty"
      "amethyst"
      "android-platform-tools"
      "background-music"
      "balenaetcher"
      "firefox"
      "font-symbols-only-nerd-font"
      "gram"
      "stolendata-mpv"
      "rotki"
      "vscodium"
      "warp"
    ];
  };

  # ── Security ───────────────────────────────────────────────────────
  security.pam.services.sudo_local.touchIdAuth = true;
}
