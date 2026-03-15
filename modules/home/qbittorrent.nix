#
# ~/nixos-config/modules/home/qbittorrent.nix
#
# qBittorrent configuration with custom theme
#
{
  config,
  ...
}: {
  home.file.".config/qBittorrent/qBittorrent.qbt".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/gars/dots/qbittorrent/qBittorrent.qbt";
}
