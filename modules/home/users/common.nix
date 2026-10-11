# gars/htmlgxn identity on top of the per-user baseline (../user-base.nix):
# git user, SSH hosts and key, theme and wallpaper selection.
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [../user-base.nix];

  my = {
    terminalTheme = "gars-yellow-dark";
    guiTheme = "gars-yellow-dark";
    wallpaper = "${config.my.repoRoot}/modules/home/users/gars/wallpapers/default.jpg";
  };

  programs.git = {
    settings.user = {
      name = "htmlgxn";
      email = "htmlgxn@pm.me";
    };
  };

  # ── SSH client config ───────────────────────────────────────────────
  programs.ssh = {
    settings = {
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
        hostname = "macbook.local";
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
