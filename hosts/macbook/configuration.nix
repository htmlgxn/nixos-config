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

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  # librewolf is flagged insecure in nixpkgs (lacks an active committer).
  # Match by name prefix so both the wrapped "librewolf" and the
  # "librewolf-unwrapped" derivation are covered, and so the allowance
  # survives version bumps instead of pinning a "librewolf-<version>" string.
  nixpkgs.config.allowInsecurePredicate = pkg: pkgs.lib.hasPrefix "librewolf" (pkgs.lib.getName pkg);

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
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
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

  # ── Post-activation fixups ─────────────────────────────────────────
  # Snapzy is only ad-hoc signed (no Developer ID), so it ships with a
  # quarantine flag. Combined with Sparkle auto-updates changing its
  # code-hash, that breaks its Screen Recording grant (capture greys out,
  # hotkeys silently do nothing). Stripping quarantine keeps its identity
  # stable so the TCC grant sticks. Screen Recording itself still has to
  # be granted once by hand — TCC is SIP-protected and can't be set here.
  system.activationScripts.postActivation.text = ''
    if [ -d /Applications/Snapzy.app ]; then
      /usr/bin/xattr -cr /Applications/Snapzy.app || true
    fi
  '';

  # ── Shell ───────────────────────────────────────────────────────────
  environment.shells = with pkgs; [nushell bashInteractive];
  users.users.htmlgxn.shell = pkgs.nushell;

  # ── Security ───────────────────────────────────────────────────────
  security.pam.services.sudo_local.touchIdAuth = true;

  # ── Remote Login (SSH) ─────────────────────────────────────────────
  services.openssh.enable = true;
}
