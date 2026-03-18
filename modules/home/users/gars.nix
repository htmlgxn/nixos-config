#
# ~/nixos-config/modules/home/users/gars.nix
#
# =============================================================================
# USER CONFIGURATION: gars
# =============================================================================
# User-specific settings for 'gars': username, home directory, shell aliases,
# dotfile symlinks, bash configuration, etc.
#
# TO ADD A NEW USER:
# 1. Copy this file to modules/home/users/<username>.nix
# 2. Update these fields:
#    - home.username = "<username>";
#    - home.homeDirectory = "/home/<username>";
#    - Update dotfile symlinks (home.file.".config/...".source)
#    - Customize shellAliases, sessionVariables, etc.
# 3. Add user to system: hosts/<host>/configuration.nix
#      users.users.<username> = {
#        isNormalUser = true;
#        extraGroups = [ "wheel" "networkmanager" ];
#      };
# 4. Register the user in the `users` attrset in flake.nix.
# =============================================================================
#
{
  config,
  pkgs,
  ...
}: let
  userName = "gars";
  homeDir = "/home/${userName}";
in {
  my = {
    primaryUser = userName;
    repoRoot = "${homeDir}/nixos-config";
    dotfilesRoot = "${homeDir}/nixos-config/home/${userName}";
  };

  home.username = userName;
  home.homeDirectory = homeDir;

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink (config.my.dotfilesRoot + "/nvim");

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
      cdn = "cd ${config.my.repoRoot}";
      ef = "nvim ${config.my.repoRoot}/flake.nix";
      eh = "nvim ${config.my.repoRoot}/modules/home/users/gars.nix";
      ecli = "nvim ${config.my.repoRoot}/modules/home/cli.nix";
      egui = "nvim ${config.my.repoRoot}/modules/home/gui-base.nix";
      ehsway = "nvim ${config.my.repoRoot}/modules/home/sway.nix";
      ehniri = "nvim ${config.my.repoRoot}/modules/home/niri.nix";
      enconf = "nvim ${config.my.repoRoot}/hosts/boreal/configuration.nix";
      edots = "cd ${config.my.dotfilesRoot}/dots";

      # ── Misc Navigation ───────────────────────────────────────────────
      cdd = "cd ~/dev";
      cdp = "cd ~/dev/projects";
      cdc = "cd ${config.my.dotfilesRoot}/dots";
      cdarch = "cd /mnt/archive";
      cdsea = "cd /mnt/seagate6";
      cdback = "cd /mnt/backup";

      # ── Rebuild: boreal ───────────────────────────────────────────────
      # nrs   — sway (production)
      nrs = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#boreal";
      # nrs-w-steam — sway (production) + steam (to be a gamer)
      nrsgaming = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#boreal-gaming";
      # nrgs  — minimal Steam + gamescope session
      nrgs = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#boreal-gamescope";
      # nrtty — tty-only mode
      nrtty = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#boreal-tty";
      # nrttycd — tty-only mode with cyberdeck cli pkgs
      nrttycd = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#boreal-tty-cyberdeck";
      # nrn   — Niri
      nrn = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#boreal-niri";
      # nrh   — Hyprland
      nrh = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#boreal-hypr";

      # ── Development: nixos-config ─────────────────────────────────────
      # fnix    — format .nix files with alejandra (excludes hardware-configuration.nix)
      fnix = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra";
      # fnixc   — format check .nix files with alejandra (excludes hardware-configuration.nix)
      fnixc = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra --check";

      # ── Rebuild: VMs ──────────────────────────────────────────────────
      nrsg = "sudo nixos-rebuild switch --flake ${config.my.repoRoot}/.#nixos-vm";

      # ── yt-dlp ────────────────────────────────────────────────────────
      ytdl = "yt-dlp -f 'bestvideo*+bestaudio' -S 'res,br,fps' -t mp4 -o '~/Downloads/output.mp4' --write-thumbnail --convert-thumbnails jpg";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      UV_PYTHON_DOWNLOADS = "never";
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
      PATH = "$HOME/.local/bin:$PATH"; # uv tools location
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
