# boreal filesystems, swap, and mountpoint ownership.
{config, ...}: let
  mkExt4Mount = uuid: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "ext4";
  };
in {
  swapDevices = [
    {
      device = "/home/swapfile";
      size = 16384;
      priority = 10;
    }
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25;
    priority = 100;
  };

  fileSystems = {
    "/mnt/archive" = mkExt4Mount "316d561a-dfc9-4269-a887-8644819b207e";
    "/mnt/seagate6" = mkExt4Mount "f248cacf-47ad-4d45-bf3e-04d8a991153c";
    "/mnt/backup" = mkExt4Mount "d3d01560-2003-4e11-88be-cc87f3448c83";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/archive 0755 ${config.my.primaryUser} users - -"
    "d /mnt/seagate6 0755 ${config.my.primaryUser} users - -"
    "d /mnt/backup 0755 ${config.my.primaryUser} users - -"
  ];
}
