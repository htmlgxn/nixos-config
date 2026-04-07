# nix-darwin system configuration for macOS Apple Silicon.
_: {
  # nix-darwin state version
  system.stateVersion = 5;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # ── macOS system preferences ───────────────────────────────────────
  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  # ── Homebrew integration (GUI apps not in nixpkgs) ─────────────────
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      # "firefox"
      # "alacritty"
    ];
  };

  # ── Security ───────────────────────────────────────────────────────
  security.pam.services.sudo_local.touchIdAuth = true;
}
