#
# ~/nixos-config/home/gars/home.nix
#

{ config, pkgs, ... }:

{
  home.username    = "gars";
  home.homeDirectory = "/home/gars";

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/nvim";

  programs.bash = {
    enable = true;

    shellAliases = {
      # ── General ──────────────────────────────────────────────────────
      c       = "clear";
      h       = "history";
      la      = "ls -a";
      ll      = "ls -la";
      ".."    = "cd ..";
      "..."   = "cd ../..";
      mkdir   = "mkdir -pv";
      grep    = "grep --color=auto";
      egrep   = "egrep --color=auto";
      fgrep   = "fgrep --color=auto";
      edit    = "nvim";
      e       = "nvim";
      calc    = "fend";

      # ── Git ──────────────────────────────────────────────────────────
      ga  = "git add .";
      gs  = "git status";
      gc  = "git commit";
      gp  = "git push";

      # ── Config navigation ─────────────────────────────────────────────
      cdc     = "cd ~/nixos-config";
      ef      = "nvim ~/nixos-config/flake.nix";
      eh      = "nvim ~/nixos-config/home/gars/home.nix";
      ecli    = "nvim ~/nixos-config/modules/home/cli.nix";
      egui    = "nvim ~/nixos-config/modules/home/gui.nix";
      econfn  = "nvim ~/nixos-config/hosts/boreal/configuration.nix";

      # ── Rebuild: boreal ───────────────────────────────────────────────
      # nrs   — sway (production)
      # nrc   — COSMIC
      # nrh   — Hyprland
      # nrn   — Niri
      # nrr   — River
      # nrw   — Wayfire
      # nrl   — LabWC
      nrs  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal";
      nrc  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-cosmic";
      nrh  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-hyprland";
      nrn  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-niri";
      nrr  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-river";
      nrw  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-wayfire";
      nrl  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-labwc";

      # ── Rebuild: VMs ─────────────────────────────────────────────────
      nrsg = "sudo nixos-rebuild switch --flake ~/nixos-config/.#nixos-vm-gui";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    bashrcExtra = ''
      # manually add to .bashrc here
    '';

    profileExtra = ''
      # manually add to .bash_profile here
    '';
  };

  home.stateVersion = "25.11";
}
