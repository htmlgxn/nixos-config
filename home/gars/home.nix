#
# ~/nixos-config/home/gars/home.nix
#
{
  config,
  pkgs,
  ...
}: {
  home.username = "gars";
  home.homeDirectory = "/home/gars";

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/nvim";

  programs.bash = {
    enable = true;

    shellAliases = {
      # ── General ───────────────────────────────────────────────────────
      c = "clear";
      h = "history";
      la = "ls -a";
      ll = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      mkdir = "mkdir -pv";
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      edit = "nvim";
      e = "nvim";
      calc = "fend";
      code = "codium";
      weather = "outside -o detailed";
      music = "ncspot";
      swapstat = "swapon --show --bytes; free -h";
      br = "broot";
      wiki = "wiki-tui";

      # ── Git ───────────────────────────────────────────────────────────
      ga = "git add .";
      gaa = "git add -A";
      gs = "git status";
      gc = "git commit";
      gcm = "git add -A && git commit -m";
      gp = "git push";
      gpom = "git push origin main";

      # ── Config Navigation ──────────────────────────────────────────────
      cdn = "cd ~/nixos-config";
      ef = "nvim ~/nixos-config/flake.nix";
      eh = "nvim ~/nixos-config/home/gars/home.nix";
      ecli = "nvim ~/nixos-config/modules/home/cli.nix";
      egui = "nvim ~/nixos-config/modules/home/gui-base.nix";
      ehsway = "nvim ~/nixos-config/modules/home/sway.nix";
      ehniri = "nvim ~/nixos-config/modules/home/niri.nix";
      enconf = "nvim ~/nixos-config/hosts/boreal/configuration.nix";
      eswayc = "nvim ~/nixos-config/home/gars/dots/sway/config";

      # ── Misc Navigation ───────────────────────────────────────────────
      cdd = "cd ~/dev";
      cdp = "cd ~/dev/projects";
      cdc = "cd ~/nixos-config/home/gars/dots";
      cdarch = "cd /mnt/archive";
      cdsea = "cd /mnt/seagate6";
      cdback = "cd /mnt/backup";

      # ── Rebuild: boreal ───────────────────────────────────────────────
      # nrs   — sway (production)
      nrs   = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal";
      # nrtty — tty-only mode 
      nrtty = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-tty";
      # nrn   — Niri
      nrn   = "sudo nixos-rebuild switch --flake ~/nixos-config/.#boreal-niri";

      # ── Development: nixos-config ─────────────────────────────────────
      # fnix    — format .nix files with alejandra (excludes hardware-configuration.nix)
      fnix = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra";
      # fnixc   — format check .nix files with alejandra (excludes hardware-configuration.nix)
      fnixc = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra --check";

      # ── Rebuild: VMs ──────────────────────────────────────────────────
      nrsg = "sudo nixos-rebuild switch --flake ~/nixos-config/.#nixos-vm";

      # ── yt-dlp ────────────────────────────────────────────────────────
      ytdl = "yt-dlp -f 'bestvideo*+bestaudio' -S 'res,br,fps' -t mp4 -o '~/Downloads/output.mp4' --write-thumbnail --convert-thumbnails jpg";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      UV_PYTHON_DOWNLOADS = "never";
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
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
