# boreal filesystems, swap, and mountpoint ownership.
{
  config,
  pkgs,
  ...
}: let
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

  programs.fuse.userAllowOther = true;

  system.fsPackages = [pkgs.mergerfs];

  fileSystems = {
    "/mnt/ironwolf" = mkExt4Mount "316d561a-dfc9-4269-a887-8644819b207e";
    "/mnt/seagate6" = mkExt4Mount "f248cacf-47ad-4d45-bf3e-04d8a991153c";
    "/mnt/backup" = mkExt4Mount "d3d01560-2003-4e11-88be-cc87f3448c83";
    "/mnt/archive" = {
      device = "/mnt/ironwolf:/mnt/seagate6";
      fsType = "fuse.mergerfs";
      options = [
        "defaults"
        "allow_other"
        "use_ino"
        "cache.files=partial"
        "dropcacheonclose=true"
        "category.create=mfs"
        "moveonenospc=true"
        "minfreespace=50G"
        "fsname=archive"
        "x-systemd.requires-mounts-for=/mnt/ironwolf"
        "x-systemd.requires-mounts-for=/mnt/seagate6"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/ironwolf 0755 ${config.my.primaryUser} users - -"
    "d /mnt/archive 0755 ${config.my.primaryUser} users - -"
    "d /mnt/seagate6 0755 ${config.my.primaryUser} users - -"
    "d /mnt/backup 0755 ${config.my.primaryUser} users - -"
  ];
}
