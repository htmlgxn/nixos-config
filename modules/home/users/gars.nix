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

    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };

    bashrcExtra = ''
      _nixos_config_outputs() {
        nix eval --raw "${config.my.repoRoot}#nixosConfigurations" \
          --apply 'configs: builtins.concatStringsSep "\n" (builtins.attrNames configs)'
      }

      _nixos_config_usage() {
        local action="$1"
        local outputs="$2"

        echo "usage: $action <output>"
        echo "available outputs:"
        while IFS= read -r output; do
          [[ -n "$output" ]] && printf '  %s\n' "$output"
        done <<< "$outputs"
      }

      _nixos_config_require_output() {
        local target="$1"
        local outputs="$2"
        grep -Fxq -- "$target" <<< "$outputs"
      }

      _nixos_config_rebuild() {
        local action="$1"
        local output="$2"
        local available_outputs

        if [[ -z "$output" ]]; then
          available_outputs="$(_nixos_config_outputs)" || return 1
          _nixos_config_usage "$action" "$available_outputs"
          return 1
        fi

        available_outputs="$(_nixos_config_outputs)" || return 1

        if ! _nixos_config_require_output "$output" "$available_outputs"; then
          echo "unknown output: $output" >&2
          _nixos_config_usage "$action" "$available_outputs" >&2
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

  # Per-user SSH host entries (shared entries are in common.nix):
  # programs.ssh.matchBlocks."myhost" = { ... };

  # ── Linux-specific user packages ───────────────────────────────────
  home.packages = with pkgs; [
    firefox
  ];

  home.stateVersion = "25.11";
}
