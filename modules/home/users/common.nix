# Shared user settings imported by both gars.nix and htmlgxn.nix.
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [../nix-workflows.nix];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop     = "${config.home.homeDirectory}/desktop";
      documents   = "${config.home.homeDirectory}/documents";
      download    = "${config.home.homeDirectory}/downloads";
      music       = "${config.home.homeDirectory}/music";
      pictures    = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates   = "${config.home.homeDirectory}/templates";
      videos      = "${config.home.homeDirectory}/videos";
    };
  };

  my = {
    terminalTheme = "gars-yellow-dark";
    guiTheme = "gars-yellow-dark";
    nvimTheme = "gars-yellow-dark";
  };

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
      br = "broot";
      wiki = "wiki-tui";
      emo = "emoji-picker-cli";
      soft = "ssh soft"; # SSH config and key are managed by home-manager (programs.ssh below)
      softrc = "ssh soft repo create";

      # ── Git ───────────────────────────────────────────────────────────
      ga = "git add .";
      gaa = "git add -A";
      gs = "git status";
      gc = "git commit";
      gcm = "git add -A && git commit -m";
      gp = "git push";
      gpom = "git push origin main";
      gpsm = "git push soft main";
      gpall = "git push origin main && git push soft main";

      # ── Config Navigation ──────────────────────────────────────────────
      cdn = "cd ${config.my.repoRoot}";
      ef = "nvim ${config.my.repoRoot}/flake.nix";
      ecli = "nvim ${config.my.repoRoot}/modules/home/cli.nix";
      egui = "nvim ${config.my.repoRoot}/modules/home/gui-base.nix";

      # ── Misc Navigation ───────────────────────────────────────────────
      cdd = "cd ~/dev";
      cdp = "cd ~/dev/projects";
      cdc = "cd ${config.my.dotfilesRoot}/dots";
      edots = "cd ${config.my.dotfilesRoot}/dots";

      # ── yt-dlp ────────────────────────────────────────────────────────
      ytdl = "yt-dlp -f 'bestvideo*+bestaudio' -S 'res,br,fps' -t mp4 -o '~/Downloads/output.mp4' --write-thumbnail --convert-thumbnails jpg";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      UV_PYTHON_DOWNLOADS = "never";
      PATH = "$HOME/.local/bin:$PATH"; # uv tools location
    };

    initExtra = ''
      # Fastfetch aliases as functions (aliases don't support arguments)
      ff() { fastfetch; }
      ff-min() { fastfetch --config minimal; }
    '';

    profileExtra = ''
      # manually add to .bash_profile here
    '';
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
