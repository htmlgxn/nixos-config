# boreal service-local values consumed by shared modules.
{...}: {
  imports = [
    ../../modules/system/soft-serve.nix
  ];

  services.soft-serve.settings.data.path = "/mnt/archive/soft-serve";

  systemd.services.soft-serve = {
    after = ["mnt-archive.mount"];
    requires = ["mnt-archive.mount"];
  };

  my.jellyfin = {
    dataDir = "/mnt/archive/jellyfin";
    mediaRoots = [
      "/mnt/archive/tv/server"
      "/mnt/archive/movies"
    ];
    transcodeSize = "4G";
  };
}
