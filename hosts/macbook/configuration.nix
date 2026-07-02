# nix-darwin system configuration for macOS Apple Silicon.
{pkgs, ...}: {
  # nix-darwin state version
  system.stateVersion = 5;

  # ── Nixpkgs overlays ──────────────────────────────────────────────
  nixpkgs.overlays = [
    (_final: prev: {
      nushell = prev.nushell.overrideAttrs (_old: {
        doCheck = false;
      });
    })
  ];
  system.primaryUser = "htmlgxn";

  # Stable hostname so `macbook.local` resolves via mDNS (matches the
  # boreal.local pattern used in the shared SSH config).
  networking.hostName = "macbook";
  networking.localHostName = "macbook";
  networking.computerName = "macbook";

  # allowUnfree and the insecure allowances (librewolf, pnpm) come from the
  # shared nixpkgsConfig in parts/lib.nix.

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
      ApplePressAndHoldEnabled = true;
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
      location = "~/Pictures/screenshots";
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
          # Screenshots — disabled in favor of Snapzy
          "28" = {enabled = false;}; # ⌘⇧3  save screen to file
          "29" = {enabled = false;}; # ⌘⌃⇧3 copy screen to clipboard
          "30" = {enabled = false;}; # ⌘⇧4  save selected area to file
          "31" = {enabled = false;}; # ⌘⌃⇧4 copy selected area to clipboard
          "184" = {enabled = false;}; # ⌘⇧5  screenshot/recording options
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
    };
  };

  # ── Homebrew integration (GUI apps not in nxpkgs) ─────────────────
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    # Keep activation reproducible and fast: no implicit `brew update`/`brew
    # upgrade` on every switch. Upgrade deliberately with `brew update && brew
    # upgrade` instead. (Silent cask upgrades were also re-signing Snapzy and
    # invalidating its TCC grants back when it was ad-hoc signed.)
    onActivation.autoUpdate = false;
    onActivation.upgrade = false;
    # Homebrew >=5.1 refuses `brew bundle --cleanup` without an explicit force
    # flag; pass it so non-interactive activation can perform the zap cleanup.
    onActivation.extraFlags = ["--force-cleanup"];
    taps = [
      {
        name = "duongductrong/snapzy";
        clone_target = "https://github.com/duongductrong/Snapzy";
      }
    ];
    brews = [
      "diskonaut"
      "blueutil"
      "apfel"
      "mdfried"
      "go" # Go compiler; apps installed imperatively via `go install ...@latest`
    ];
    casks = [
      "android-platform-tools"
      "freecad"
      "protonvpn"
      "codex"
      "claude"
      "kicad"
      "jellyfin-media-player"
      "zoom"
      "calibre"
      "signal"
      "orcaslicer"
      "font-symbols-only-nerd-font"
      "sol"
      "cmux"
      "beeper"
      "snapzy"
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
