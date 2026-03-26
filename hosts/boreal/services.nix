# boreal service-local values consumed by shared modules.
{...}: {
  imports = [
    ../../modules/system/soft-serve.nix
  ];

  my.jellyfin = {
    dataDir = "/mnt/archive/jellyfin";
    mediaRoots = [
      "/mnt/archive/tv/server"
      "/mnt/archive/movies"
    ];
    transcodeSize = "4G";
  };
}
