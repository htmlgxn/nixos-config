# macbook-specific home-manager configuration.
# Included automatically for every macbook output via hostHomeModules.
{config, ...}: {
  # macOS nushell looks in ~/Library/Application Support/nushell/ by default.
  # Symlink it to the XDG path so HM-managed config is picked up.
  home.file."Library/Application Support/nushell".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nushell";

  programs.bash.shellAliases.nrs = "nh darwin switch . -H macbook";
  programs.nushell.shellAliases.nrs = "nh darwin switch . -H macbook";

  # ── macOS SSH entries ────────────────────────────────────────────────
  programs.ssh.matchBlocks."github.com" = {
    hostname = "github.com";
    extraOptions = {
      AddKeysToAgent = "yes";
      UseKeychain = "yes";
    };
    identityFile = "~/.ssh/id_ed25519";
  };
}
