# Shared user settings imported by both gars.nix and htmlgxn.nix.
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../nix-workflows.nix
    ../bash.nix
    ../nushell.nix
    ../starship.nix
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
    };
  };

  my = {
    terminalTheme = "gars-yellow-dark";
    guiTheme = "gars-yellow-dark";
    wallpaper = "${config.my.repoRoot}/modules/home/users/gars/wallpapers/default.jpg";
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "htmlgxn";
      email = "htmlgxn@pm.me";
    };
  };

  # ── SSH client config ───────────────────────────────────────────────
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
      };
      # ── Shared infrastructure ──────────────────────────────────────
      "soft" = {
        hostname = config.my.borealHost;
        port = 23231;
        user = "gars";
        addressFamily = "inet";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "boreal" = {
        hostname = config.my.borealHost;
        port = 2200;
        user = "gars";
        addressFamily = "inet";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "macbook" = {
        hostname = "192.168.2.102";
        user = "htmlgxn";
        addressFamily = "inet";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      # ── Per-user / per-host blocks ─────────────────────────────────
      # Add additional Host entries in gars.nix or htmlgxn.nix.
      # Do NOT edit ~/.ssh/config directly — home-manager owns it.
    };
  };

  home.activation.generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen \
        -t ed25519 \
        -C "${config.home.username}@$(hostname)" \
        -f "$HOME/.ssh/id_ed25519" \
        -N ""
    fi
  '';

  # ── User packages available everywhere ─────────────────────────────
  home.packages = [];
}
