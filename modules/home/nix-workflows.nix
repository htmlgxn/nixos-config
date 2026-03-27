{config, ...}: {
  programs.bash = {
    shellAliases = {
      nflk = "nvim ${config.my.repoRoot}/flake.nix";
      nfmt = "fnix";
    };

    bashrcExtra = ''
      _nixcfg_repo="${config.my.repoRoot}"

      _nixcfg_command_exists() {
        command -v "$1" >/dev/null 2>&1
      }

      _nixcfg_require_command() {
        local cmd="$1"

        if _nixcfg_command_exists "$cmd"; then
          return 0
        fi

        printf 'required command not found: %s\n' "$cmd" >&2
        return 1
      }

      _nixcfg_outputs() {
        local attr="$1"

        nix eval --raw "$_nixcfg_repo#$attr" \
          --apply 'configs: builtins.concatStringsSep "\n" (builtins.attrNames configs)'
      }

      _nixcfg_usage() {
        local action="$1"
        local outputs="$2"

        printf 'usage: %s <output>\n' "$action" >&2
        printf 'available outputs:\n' >&2

        while IFS= read -r output; do
          [[ -n "$output" ]] && printf '  %s\n' "$output" >&2
        done <<< "$outputs"
      }

      _nixcfg_require_output() {
        local attr="$1"
        local target="$2"
        local outputs

        outputs="$(_nixcfg_outputs "$attr")" || return 1

        if grep -Fxq -- "$target" <<< "$outputs"; then
          return 0
        fi

        printf 'unknown output: %s\n' "$target" >&2
        _nixcfg_usage "$attr" "$outputs"
        return 1
      }

      _nixcfg_print_outputs() {
        local label="$1"
        local attr="$2"
        local outputs

        outputs="$(_nixcfg_outputs "$attr")" || return 1

        printf '%s:\n' "$label"
        while IFS= read -r output; do
          [[ -n "$output" ]] && printf '  %s\n' "$output"
        done <<< "$outputs"
      }

      _nixcfg_nixos_installable() {
        printf '%s#nixosConfigurations.%s.config.system.build.toplevel' "$_nixcfg_repo" "$1"
      }

      _nixcfg_realise_nixos_output() {
        local output="$1"

        _nixcfg_require_output nixosConfigurations "$output" || return 1
        nix build --no-link --print-out-paths "$(_nixcfg_nixos_installable "$output")"
      }

      _nixcfg_resolve_installable() {
        local target="$1"

        case "$target" in
          *#*|/*|path:*)
            printf '%s\n' "$target"
            ;;
          *)
            printf '%s#%s\n' "$_nixcfg_repo" "$target"
            ;;
        esac
      }

      _nixcfg_in_repo() {
        (
          cd "$_nixcfg_repo" || exit 1
          "$@"
        )
      }

      _nixcfg_system_profile_link() {
        local generation="$1"

        if [[ -z "$generation" || "$generation" == "current" ]]; then
          printf '%s\n' /run/current-system
          return 0
        fi

        printf '/nix/var/nix/profiles/system-%s-link\n' "$generation"
      }

      _nixcfg_previous_system_generation() {
        nix-env -p /nix/var/nix/profiles/system --list-generations \
          | awk '$NF == "(current)" { print prev; exit } { prev = $1 }'
      }

      _nixcfg_run_nixos_rebuild() {
        local action="$1"
        local output="$2"
        shift 2

        _nixcfg_require_command nixos-rebuild || return 1
        _nixcfg_require_output nixosConfigurations "$output" || return 1

        sudo nixos-rebuild "$action" --flake "$_nixcfg_repo/.#$output" "$@"
      }

      _nixcfg_run_darwin_rebuild() {
        local action="$1"
        local output="''${2:-macbook}"

        _nixcfg_require_command darwin-rebuild || return 1
        _nixcfg_require_output darwinConfigurations "$output" || return 1

        darwin-rebuild "$action" --flake "$_nixcfg_repo#$output"
      }

      _nixcfg_run_home_manager() {
        local action="$1"
        local output="''${2:-fedora-arm}"

        _nixcfg_require_command home-manager || return 1
        _nixcfg_require_output homeConfigurations "$output" || return 1

        home-manager "$action" --flake "$_nixcfg_repo#$output"
      }

      _nixcfg_copy_nixos_output() {
        local output="$1"
        local host="$2"
        local store_path

        if [[ -z "$output" || -z "$host" ]]; then
          printf 'usage: ncopy <nixos-output> <ssh-host>\n' >&2
          return 1
        fi

        store_path="$(_nixcfg_realise_nixos_output "$output")" || return 1
        nix copy --to "ssh://$host" "$store_path" || return 1
        printf '%s\n' "$store_path"
      }

      _nixcfg_activate_copied_output() {
        local action="$1"
        local output="$2"
        local target_host="$3"
        local store_path

        if [[ -z "$output" || -z "$target_host" ]]; then
          printf 'usage: ncopy-%s <nixos-output> <target-host>\n' "$action" >&2
          return 1
        fi

        _nixcfg_require_command ssh || return 1
        store_path="$(_nixcfg_copy_nixos_output "$output" "$target_host")" || return 1

        case "$action" in
          test)
            ssh "$target_host" "sudo '$store_path/bin/switch-to-configuration' test"
            ;;
          switch)
            ssh "$target_host" "sudo nix-env -p /nix/var/nix/profiles/system --set '$store_path' && sudo '$store_path/bin/switch-to-configuration' switch"
            ;;
          *)
            printf 'unsupported action: %s\n' "$action" >&2
            return 1
            ;;
        esac
      }

      nout() {
        _nixcfg_print_outputs "nixosConfigurations" nixosConfigurations || return 1
        printf '\n'
        _nixcfg_print_outputs "darwinConfigurations" darwinConfigurations || return 1
        printf '\n'
        _nixcfg_print_outputs "homeConfigurations" homeConfigurations
      }

      noutn() {
        _nixcfg_print_outputs "nixosConfigurations" nixosConfigurations
      }

      noutd() {
        _nixcfg_print_outputs "darwinConfigurations" darwinConfigurations
      }

      nouth() {
        _nixcfg_print_outputs "homeConfigurations" homeConfigurations
      }

      npath() {
        printf 'repoRoot=%s\n' "${config.my.repoRoot}"
        printf 'dotfilesRoot=%s\n' "${config.my.dotfilesRoot}"
        printf 'containersRoot=%s\n' "${config.my.containersRoot}"
        printf 'flakeRef=%s\n' "$_nixcfg_repo"
      }

      nshow() {
        local output="$1"
        local found=0

        if [[ -z "$output" ]]; then
          printf 'usage: nshow <output>\n' >&2
          return 1
        fi

        if grep -Fxq -- "$output" <<< "$(_nixcfg_outputs nixosConfigurations)"; then
          printf 'type: nixos\n'
          printf 'installable: %s\n' "$(_nixcfg_nixos_installable "$output")"
          printf 'switch: nr %s\n' "$output"
          found=1
        fi

        if grep -Fxq -- "$output" <<< "$(_nixcfg_outputs darwinConfigurations)"; then
          printf 'type: darwin\n'
          printf 'installable: %s#darwinConfigurations.%s.system\n' "$_nixcfg_repo" "$output"
          printf 'switch: ndrs %s\n' "$output"
          found=1
        fi

        if grep -Fxq -- "$output" <<< "$(_nixcfg_outputs homeConfigurations)"; then
          printf 'type: home-manager\n'
          printf 'installable: %s#homeConfigurations.%s.activationPackage\n' "$_nixcfg_repo" "$output"
          printf 'switch: nhms %s\n' "$output"
          found=1
        fi

        if [[ "$found" -eq 0 ]]; then
          printf 'unknown output: %s\n' "$output" >&2
          return 1
        fi
      }

      neval() {
        if [[ -z "$1" ]]; then
          printf 'usage: neval <attr-path> [extra nix eval args]\n' >&2
          return 1
        fi

        local target="$1"
        shift
        nix eval "$_nixcfg_repo#$target" "$@"
      }

      fnix() {
        _nixcfg_in_repo bash -lc "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra"
      }

      fnixc() {
        _nixcfg_in_repo bash -lc "rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra --check"
      }

      nb() {
        if [[ -z "$1" ]]; then
          printf 'usage: nb <attr-path> [extra nix build args]\n' >&2
          return 1
        fi

        local target="$1"
        shift
        nix build "$_nixcfg_repo#$target" "$@"
      }

      nbi() {
        if [[ -z "$1" ]]; then
          printf 'usage: nbi <installable> [extra nix build args]\n' >&2
          return 1
        fi

        nix build "$@"
      }

      nchk() {
        local flake_ref="''${1:-$_nixcfg_repo}"
        nix flake check "$flake_ref"
      }

      nmeta() {
        if [[ -z "$1" ]]; then
          printf 'usage: nmeta <installable-or-attr-path>\n' >&2
          return 1
        fi

        nix path-info -Sh "$(_nixcfg_resolve_installable "$1")"
      }

      nwhy() {
        if [[ $# -lt 2 ]]; then
          printf 'usage: nwhy <installable-a> <installable-b>\n' >&2
          return 1
        fi

        nix why-depends "$(_nixcfg_resolve_installable "$1")" "$(_nixcfg_resolve_installable "$2")"
      }

      ncheck() {
        fnixc || return 1
        nix flake check "$_nixcfg_repo"
      }

      ncheck-full() {
        fnixc || return 1
        nix flake check "$_nixcfg_repo" || return 1
        _nixcfg_outputs nixosConfigurations >/dev/null || return 1
        _nixcfg_outputs darwinConfigurations >/dev/null || return 1
        _nixcfg_outputs homeConfigurations >/dev/null || return 1

        if _nixcfg_command_exists deadnix; then
          deadnix "$_nixcfg_repo" || return 1
        fi

        if _nixcfg_command_exists statix; then
          statix check "$_nixcfg_repo" || return 1
        fi
      }

      ndead() {
        _nixcfg_require_command deadnix || return 1
        deadnix "$_nixcfg_repo" "$@"
      }

      nstatix() {
        _nixcfg_require_command statix || return 1
        statix check "$_nixcfg_repo" "$@"
      }

      nr() {
        _nixcfg_run_nixos_rebuild switch "$1"
      }

      nrb() {
        _nixcfg_run_nixos_rebuild build "$1"
      }

      nrt() {
        _nixcfg_run_nixos_rebuild test "$1"
      }

      nrd() {
        _nixcfg_run_nixos_rebuild dry-build "$1"
      }

      ndrs() {
        _nixcfg_run_darwin_rebuild switch "$1"
      }

      ndrb() {
        _nixcfg_run_darwin_rebuild build "$1"
      }

      nhms() {
        _nixcfg_run_home_manager switch "$1"
      }

      nhmb() {
        _nixcfg_run_home_manager build "$1"
      }

      ncopy() {
        local output="$1"
        local host="$2"
        _nixcfg_copy_nixos_output "$output" "$host"
      }

      nremote-build() {
        local output="$1"
        local target_host="$2"

        if [[ -z "$output" || -z "$target_host" ]]; then
          printf 'usage: nremote-build <nixos-output> <target-host>\n' >&2
          return 1
        fi

        _nixcfg_run_nixos_rebuild build "$output" --target-host "$target_host"
      }

      nremote-test() {
        local output="$1"
        local target_host="$2"

        if [[ -z "$output" || -z "$target_host" ]]; then
          printf 'usage: nremote-test <nixos-output> <target-host>\n' >&2
          return 1
        fi

        _nixcfg_run_nixos_rebuild test "$output" --target-host "$target_host"
      }

      nremote-switch() {
        local output="$1"
        local target_host="$2"

        if [[ -z "$output" || -z "$target_host" ]]; then
          printf 'usage: nremote-switch <nixos-output> <target-host>\n' >&2
          return 1
        fi

        _nixcfg_run_nixos_rebuild switch "$output" --target-host "$target_host"
      }

      nboh() {
        local output="$1"
        local build_host="$2"
        local target_host="$3"
        local action="''${4:-build}"

        if [[ -z "$output" || -z "$build_host" || -z "$target_host" ]]; then
          printf 'usage: nboh <nixos-output> <build-host> <target-host> [build|test|switch]\n' >&2
          return 1
        fi

        _nixcfg_run_nixos_rebuild "$action" "$output" \
          --build-host "$build_host" \
          --target-host "$target_host"
      }

      ncopy-test() {
        _nixcfg_activate_copied_output test "$1" "$2"
      }

      ncopy-switch() {
        _nixcfg_activate_copied_output switch "$1" "$2"
      }

      ncopy-activate() {
        ncopy-test "$1" "$2"
      }

      nfu() {
        _nixcfg_in_repo nix flake update "$@"
      }

      nfu-input() {
        if [[ -z "$1" ]]; then
          printf 'usage: nfu-input <input-name>\n' >&2
          return 1
        fi

        _nixcfg_in_repo nix flake lock --update-input "$1"
      }

      nlock() {
        _nixcfg_in_repo git status --short -- flake.lock
        _nixcfg_in_repo git diff -- flake.lock
      }

      nrepl() {
        nix repl "$_nixcfg_repo"
      }

      ngen-system() {
        _nixcfg_require_command nix-env || return 1
        nix-env -p /nix/var/nix/profiles/system --list-generations
      }

      ngen-hm() {
        _nixcfg_require_command home-manager || return 1
        home-manager generations
      }

      ngen-all() {
        printf 'system generations:\n'
        ngen-system || return 1

        if _nixcfg_command_exists home-manager; then
          printf '\n'
          printf 'home-manager generations:\n'
          ngen-hm || return 1
        fi
      }

      ndiff-system() {
        local from_generation="''${1:-previous}"
        local to_generation="''${2:-current}"
        local from_path
        local to_path

        _nixcfg_require_command nix || return 1

        if [[ "$from_generation" == "previous" ]]; then
          from_generation="$(_nixcfg_previous_system_generation)"
        fi

        if [[ -z "$from_generation" ]]; then
          printf 'could not determine previous system generation\n' >&2
          return 1
        fi

        from_path="$(_nixcfg_system_profile_link "$from_generation")"
        to_path="$(_nixcfg_system_profile_link "$to_generation")"

        if [[ ! -e "$from_path" ]]; then
          printf 'system generation path not found: %s\n' "$from_path" >&2
          return 1
        fi

        if [[ ! -e "$to_path" ]]; then
          printf 'system generation path not found: %s\n' "$to_path" >&2
          return 1
        fi

        nix store diff-closures "$from_path" "$to_path"
      }

      nsize() {
        if [[ -z "$1" ]]; then
          printf 'usage: nsize <installable-or-attr-path>\n' >&2
          return 1
        fi

        nix path-info -Sh "$(_nixcfg_resolve_installable "$1")"
      }

      ntop-store() {
        local count="''${1:-20}"

        if [[ ! -d /nix/store ]]; then
          printf '/nix/store is not present on this host\n' >&2
          return 1
        fi

        du -sh /nix/store/* 2>/dev/null | sort -h | tail -n "$count"
      }

      nspace-why() {
        nspace || return 1
        printf '\n'

        if [[ -d /nix/store ]]; then
          printf '/nix/store summary:\n'
          du -sh /nix/store 2>/dev/null
          printf '\n'
        fi

        if [[ -d /nix/var/nix/profiles ]]; then
          printf 'profile roots:\n'
          du -sh /nix/var/nix/profiles 2>/dev/null
          printf '\n'
        fi

        if [[ -d "$HOME/.local/state/nix/profiles" ]]; then
          printf 'home-manager profiles:\n'
          du -sh "$HOME/.local/state/nix/profiles" 2>/dev/null
          printf '\n'
        fi

        printf 'largest store paths:\n'
        ntop-store 10
      }

      nclean-roots() {
        nix-store --gc --print-roots
      }

      nclean-gc() {
        nix store gc "$@"
      }

      nclean-system() {
        _nixcfg_require_command nix-collect-garbage || return 1
        sudo nix-collect-garbage -d
      }

      nclean-hm() {
        local age="''${1:--7 days}"

        _nixcfg_require_command home-manager || return 1
        home-manager expire-generations "$age"
      }

      nclean-all() {
        local age="''${1:--7 days}"

        nclean-system || return 1

        if _nixcfg_command_exists home-manager; then
          nclean-hm "$age" || return 1
        fi

        nclean-gc
      }

      nspace() {
        if [[ -d /nix/store ]]; then
          df -h / /nix/store
          return 0
        fi

        df -h /
      }

      npre() {
        local output="$1"

        if [[ -z "$output" ]]; then
          printf 'usage: npre <nixos-output>\n' >&2
          return 1
        fi

        fnixc || return 1
        nrd "$output"
      }

      npre-full() {
        ncheck-full
      }

      nship() {
        local output="$1"

        if [[ -z "$output" ]]; then
          printf 'usage: nship <nixos-output>\n' >&2
          return 1
        fi

        npre "$output" || return 1
        nr "$output"
      }

      nship-remote() {
        local output="$1"
        local build_host="$2"
        local target_host="$3"

        if [[ -z "$output" || -z "$build_host" || -z "$target_host" ]]; then
          printf 'usage: nship-remote <nixos-output> <build-host> <target-host>\n' >&2
          return 1
        fi

        nboh "$output" "$build_host" "$target_host" switch
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

        _nixcfg_require_command nix-search-tv || return 1
        _nixcfg_require_command fzf || return 1

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
}
