#
# ~/nixos-config/modules/home/qbittorrent.nix
#
# qBittorrent configuration with custom theme
#
{
  config,
  pkgs,
  ...
}: let
  themePath = "${config.home.homeDirectory}/nixos-config/home/gars/dots/qbittorrent/qBittorrent.qbt";
  configPath = "${config.home.homeDirectory}/.config/qBittorrent/qBittorrent.conf";
in {
  home.file.".config/qBittorrent/qBittorrent.qbt".source =
    config.lib.file.mkOutOfStoreSymlink themePath;

  home.activation.qbittorrentTheme = ''
    if [ -f "${configPath}" ]; then
      # Remove existing theme settings if present
      sed -i '/^General\\UseCustomUITheme=/d' "${configPath}"
      sed -i '/^General\\CustomUIThemePath=/d' "${configPath}"
      
      # Add theme settings under [Preferences] section
      if grep -q '^\[Preferences\]' "${configPath}"; then
        sed -i '/^\[Preferences\]/a General\\UseCustomUITheme=true\nGeneral\\CustomUIThemePath=${themePath}' "${configPath}"
      else
        printf '[Preferences]\nGeneral\\UseCustomUITheme=true\nGeneral\\CustomUIThemePath=%s\n' "${themePath}" >> "${configPath}"
      fi
    fi
  '';
}
