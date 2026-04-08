# nix-darwin system configuration for macOS Apple Silicon.
_: {
  # nix-darwin state version
  system.stateVersion = 5;
  system.primaryUser = "htmlgxn";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # ── macOS system preferences ───────────────────────────────────────
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
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
      "mpv"
      "rotki"
      "vscodium"
      "warp"
    ];
  };

  # ── Security ───────────────────────────────────────────────────────
  security.pam.services.sudo_local.touchIdAuth = true;
}
