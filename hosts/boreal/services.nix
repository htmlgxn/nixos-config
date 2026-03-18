# boreal service-local values consumed by shared modules.
{...}: {
  my.jellyfin = {
    dataDir = "/mnt/ironwolf/jellyfin";
    mediaRoots = [
      "/mnt/seagate6"
      "/mnt/seagate6/Movies"
    ];
    transcodeSize = "4G";
  };
}
