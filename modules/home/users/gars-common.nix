# Shared user settings imported by both gars.nix and htmlgxn.nix.
{
  config,
  pkgs,
  lib,
  ...
}: {
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

      # ── Development: nixos-config ─────────────────────────────────────
      fnix = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra";
      fnixc = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra --check";

      # ── yt-dlp ────────────────────────────────────────────────────────
      ytdl = "yt-dlp -f 'bestvideo*+bestaudio' -S 'res,br,fps' -t mp4 -o '~/Downloads/output.mp4' --write-thumbnail --convert-thumbnails jpg";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      UV_PYTHON_DOWNLOADS = "never";
      PATH = "$HOME/.local/bin:$PATH"; # uv tools location
    };

    profileExtra = ''
      # manually add to .bash_profile here
    '';
  };

  # ── User packages available everywhere ─────────────────────────────
  home.packages = with pkgs; [
    alacritty
  ];
}
