# Primary Home Manager user module for `gars` (NixOS / Linux hosts).
{
  config,
  pkgs,
  ...
}: let
  userName = "gars";
  homeDir = "/home/${userName}";
in {
  imports = [./common.nix];

  my = {
    primaryUser = userName;
    repoRoot = "${homeDir}/nixos-config";
    dotfilesRoot = "${homeDir}/nixos-config/home/${userName}";
    dotfilesNixPath = ../../../home/gars;
    containersRoot = "${homeDir}/nixos-config/containers";
    wallpaper = "${homeDir}/nixos-config/home/${userName}/wallpapers/default.jpg";
  };

  home.username = userName;
  home.homeDirectory = homeDir;

  programs.bash = {
    shellAliases = {
      # ── Test ─────────────────────────────────────────────────────────
      wiki-explore = "cd ~/wmd/ && fzf --print0 | xargs -0 -o mdt";
      wiki-pick = "cd ~/wmd/ && fzf --print0 | xargs -0 -o";

      # ── NixOS-specific shortcuts ─────────────────────────────────────
      eh = "nvim ${config.my.repoRoot}/modules/home/users/gars.nix";
      ehsway = "nvim ${config.my.repoRoot}/modules/home/sway.nix";
      ehniri = "nvim ${config.my.repoRoot}/modules/home/niri.nix";
      enconf = "nvim ${config.my.repoRoot}/hosts/boreal/configuration.nix";
      nrs = "nr boreal";
      nrtty = "nr boreal-tty";
      swapstat = "swapon --show --bytes; free -h";
      mkkey = "ssh-keygen -t ed25519 -C \"htmlgxn@pm.me\"";

      # ── Mount navigation (boreal-specific) ────────────────────────────
      cdarch = "cd /mnt/archive";
      cdsea = "cd /mnt/seagate6";
      cdback = "cd /mnt/backup";
    };

    sessionVariables = {};
  };

  # Per-user SSH host entries (shared entries are in common.nix):
  # programs.ssh.matchBlocks."myhost" = { ... };

  # ── Linux-specific user packages ───────────────────────────────────
  home.packages = with pkgs; [
    firefox
  ];

  home.stateVersion = "25.11";
}
