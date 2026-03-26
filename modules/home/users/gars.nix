# Primary Home Manager user module for `gars` (NixOS / Linux hosts).
{
  config,
  pkgs,
  lib,
  ...
}: let
  userName = "gars";
  homeDir = "/home/${userName}";
in {
  imports = [./gars-common.nix];

  my = {
    primaryUser = userName;
    repoRoot = "${homeDir}/nixos-config";
    dotfilesRoot = "${homeDir}/nixos-config/home/${userName}";
    containersRoot = "${homeDir}/nixos-config/containers";
    ollamaPackage = lib.mkDefault pkgs.ollama;
  };

  home.username = userName;
  home.homeDirectory = homeDir;

  programs.bash = {
    shellAliases = {
      # ── NixOS-specific shortcuts ─────────────────────────────────────
      eh = "nvim ${config.my.repoRoot}/modules/home/users/gars.nix";
      ehsway = "nvim ${config.my.repoRoot}/modules/home/sway.nix";
      ehniri = "nvim ${config.my.repoRoot}/modules/home/niri.nix";
      enconf = "nvim ${config.my.repoRoot}/hosts/boreal/configuration.nix";
      nrs = "nr boreal";
      nrtty = "nr boreal-tty";
      swapstat = "swapon --show --bytes; free -h";

      # ── Mount navigation (boreal-specific) ────────────────────────────
      cdarch = "cd /mnt/archive";
      cdsea = "cd /mnt/seagate6";
      cdback = "cd /mnt/backup";
    };

    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
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
        cyberdeck-tty
        rpi4-tty
        rpi4-sway
        rpi4-tty-cyberdeck
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
        local selection
        local fzf_args=(
          --preview 'nix-search-tv preview {}'
          --preview-window 'right:60%:wrap'
          --scheme history
          --prompt 'nix> '
        )

        if [[ -n "$query" ]]; then
          fzf_args+=(--query "$query")
        fi

        selection="$(nix-search-tv print | fzf "''${fzf_args[@]}")" || return $?

        if [[ "$selection" == nixpkgs/* ]]; then
          printf '%s\n' "''${selection#nixpkgs/}"
          return 0
        fi

        printf '%s\n' "$selection"
      }
    '';
  };

  # ── Linux-specific user packages ───────────────────────────────────
  home.packages = with pkgs; [
    firefox
  ];

  home.stateVersion = "25.11";
}
