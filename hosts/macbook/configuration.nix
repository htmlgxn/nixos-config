# nix-darwin system configuration for macOS Apple Silicon.
{pkgs, ...}: {
  # nix-darwin state version
  system.stateVersion = 5;
  system.primaryUser = "htmlgxn";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # ── Firewall ──────────────────────────────────────────────────────
  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    allowSigned = true;
    allowSignedApp = true;
  };

  # ── macOS system preferences ───────────────────────────────────────
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      NSAutomaticWindowAnimationsEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
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
      FXEnableExtensionChangeWarning = false;
      FXDefaultSearchScope = "SCcf";
      ShowStatusBar = true;
      QuitMenuItem = true;
    };

    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    screencapture = {
      location = "~/downloads/screenshots";
      type = "png";
      disable-shadow = true;
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    controlcenter.BatteryShowPercentage = true;

    spaces.spans-displays = false;

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "64" = {enabled = false;};
          "65" = {enabled = false;};
        };
      };

      "com.apple.Siri" = {
        SiriPrefStashedStatusMenuVisible = false;
        StatusMenuVisible = false;
        VoiceTriggerUserEnabled = false;
      };

      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };

      "com.apple.SubmitDiagInfo".AutoSubmit = false;

      "com.apple.CrashReporter".DialogType = "none";

      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      "com.apple.GameCenter".GameCenterEnabled = false;

      "com.apple.lookup.shared".LookupSuggestionsDisabled = true;

      "com.apple.Safari" = {
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
        SendDoNotTrackHTTPHeader = true;
        PreloadTopHit = false;
        AutoOpenSafeDownloads = false;
      };
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

  # ── Shell ───────────────────────────────────────────────────────────
  environment.shells = with pkgs; [nushell bashInteractive];
  users.users.htmlgxn.shell = pkgs.nushell;

  # ── Security ───────────────────────────────────────────────────────
  security.pam.services.sudo_local.touchIdAuth = true;

  # ── Remote Login (SSH) ─────────────────────────────────────────────
  services.openssh.enable = true;
}
