
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
      # ── General ───────────────────────────────────────────────────────
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
      code    = "codium";
      weather = "outside -o detailed";
      music   = "ncspot";

      # ── Git ───────────────────────────────────────────────────────────
      ga    = "git add .";
      gaa   = "git add -A";
      gs    = "git status";
      gc    = "git commit";
      gcm   = "git commit -m";
      gp    = "git push";
      gpom  = "git push origin main";

      # ── Config navigation ─────────────────────────────────────────────
      cdc     = "cd ~/nixos-config";
      ef      = "nvim ~/nixos-config/flake.nix";
      eh      = "nvim ~/nixos-config/home/gars/home.nix";
      ecli    = "nvim ~/nixos-config/modules/home/cli.nix";
      egui    = "nvim ~/nixos-config/modules/home/gui-base.nix";
      ehsway  = "nvim ~/nixos-config/modules/home/sway.nix";
      ehniri  = "nvim ~/nixos-config/modules/home/niri.nix";
      enconf  = "nvim ~/nixos-config/hosts/boreal/configuration.nix";
      eswayc  = "nvim ~/nixos-config/home/gars/dots/sway/config";

      # ── Rebuild: boreal ───────────────────────────────────────────────
      # nrs   — sway (production)
      nrs  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal";
      # nrn   — Niri
      nrn  = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-niri";

      # ── Rebuild: VMs ──────────────────────────────────────────────────
      nrsg = "sudo nixos-rebuild switch --flake ~/nixos-config/.#nixos-vm";

      # ── yt-dlp ────────────────────────────────────────────────────────
      ytdl = "yt-dlp -f 'bestvideo*+bestaudio' -S 'res,br,fps' -t mp4 -o '~/Downloads/output.mp4' --write-thumbnail --convert-thumbnails jpg";

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
