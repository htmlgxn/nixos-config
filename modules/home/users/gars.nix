# Primary Home Manager user module for `gars`.
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

      # ── Development: nixos-config ─────────────────────────────────────
      # fnix    — format .nix files with alejandra (excludes hardware-configuration.nix)
      fnix = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra";
      # fnixc   — format check .nix files with alejandra (excludes hardware-configuration.nix)
      fnixc = "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra --check";
      nrs = "nr boreal";
      nrtty = "nr boreal-tty";

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
      _nixos_config_outputs=(
        boreal
        boreal-gaming
        boreal-gamescope
        boreal-niri
        boreal-hypr
        boreal-tty
        boreal-tty-cyberdeck
        nixos-vm
      )

      _nixos_config_usage() {
        echo "usage: $1 <output>"
        echo "available outputs:"
        printf '  %s\n' "''${_nixos_config_outputs[@]}"
      }

      _nixos_config_has_output() {
        local target="$1"
        local output
        for output in "''${_nixos_config_outputs[@]}"; do
          if [[ "$output" == "$target" ]]; then
            return 0
          fi
        done
        return 1
      }

      _nixos_config_rebuild() {
        local action="$1"
        local output="$2"

        if [[ -z "$output" ]]; then
          _nixos_config_usage "$action"
          return 1
        fi

        if ! _nixos_config_has_output "$output"; then
          echo "unknown output: $output" >&2
          _nixos_config_usage "$action" >&2
          return 1
        fi

        sudo nixos-rebuild "$action" --flake "${config.my.repoRoot}/.#$output"
      }

      nr() {
        _nixos_config_rebuild switch "$1"
      }

      nrb() {
        _nixos_config_rebuild build "$1"
      }

      ns() {
        local query="$*"
        local fzf_args=(
          --preview 'nix-search-tv preview {}'
          --preview-window 'right:60%:wrap'
          --scheme history
          --prompt 'nix> '
        )

        if [[ -n "$query" ]]; then
          fzf_args+=(--query "$query")
        fi

        nix-search-tv print | fzf "''${fzf_args[@]}"
      }
    '';

    profileExtra = ''
      # manually add to .bash_profile here
    '';
  };

  home.stateVersion = "25.11";
}
