#
# ~/nixos-config/modules/system/jellyfin.nix
#
# Jellyfin media server configuration.
# - Media: /mnt/seagate6/Movies
# - Data: /mnt/archive/jellyfin (config, cache, database)
# - Transcodes: tmpfs (4GB, RAM-based)
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.jellyfin = {
    enable = true;
    package = pkgs.jellyfin;

    # Open port 8096 (firewall rules to be added separately)
    openFirewall = false;

    # User/group configuration
    user = "jellyfin";
    group = "jellyfin";

    # Data directory off root partition
    dataDir = "/mnt/archive/jellyfin";
  };

  # Create Jellyfin data directory with correct ownership
  # and transcode directory (tmpfs will mount over it)
  systemd.tmpfiles.rules = [
    "d /mnt/archive/jellyfin 0755 jellyfin jellyfin - -"
    "d /mnt/archive/jellyfin/config 0750 jellyfin jellyfin - -"
    "d /mnt/archive/jellyfin/cache 0750 jellyfin jellyfin - -"
    "d /mnt/archive/jellyfin/data 0750 jellyfin jellyfin - -"
    "d /var/lib/jellyfin/transcodes 0750 jellyfin jellyfin - -"
    "A /mnt/seagate6 - - - - u:jellyfin:rx"
    "A /mnt/seagate6 - - - - d:u:jellyfin:rx"
  ];

  # Mount tmpfs for transcodes (4GB limit, RAM-based)
  systemd.mounts = [
    {
      what = "tmpfs";
      where = "/var/lib/jellyfin/transcodes";
      type = "tmpfs";
      options = "size=4G,mode=0750,uid=jellyfin,gid=jellyfin";
      wantedBy = [ "jellyfin.service" ];
      before = [ "jellyfin.service" ];
    }
  ];

  # Ensure gars can manage Jellyfin files and logs
  users.groups.jellyfin.members = [ "gars" ];

  # Allow Jellyfin to access media on /mnt/seagate6
  systemd.services.jellyfin.serviceConfig = {
    SupplementaryGroups = [ "gars" ];
    Environment = [
      "LIBVA_DRIVER_NAME=radeonsi"
    ];
  };

  systemd.services.jellyfin.unitConfig = {
    RequiresMountsFor = [
      "/mnt/archive"
      "/mnt/seagate6"
    ];
  };

  # Hardware acceleration (AMD RX 570)
  hardware.graphics.enable = true;
}
