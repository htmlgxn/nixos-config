# boreal service-local values consumed by shared modules.
{lib, ...}: {
  imports = [
    ../../modules/system/soft-serve.nix
  ];

  users.users.soft-serve = {
    isSystemUser = true;
    group = "soft-serve";
  };
  users.groups.soft-serve = {};

  systemd.services.soft-serve = {
    after = ["mnt-archive.mount"];
    requires = ["mnt-archive.mount"];
    environment = {
      SOFT_SERVE_DATA_PATH = lib.mkForce "/mnt/archive/soft-serve";
      SOFT_SERVE_INITIAL_ADMIN_KEYS = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPyzf/Oy8OFx6SK4wxhIgwyzMEXu8tso01ZpfS3WngG";
    };
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "soft-serve";
      Group = lib.mkForce "soft-serve";
    };
  };

  my.jellyfin = {
    vaDriver = "radeonsi";
    dataDir = "/mnt/archive/jellyfin";
    mediaRoots = [
      "/mnt/archive/tv/server"
      "/mnt/archive/movies"
    ];
    transcodeSize = "4G";
  };
}
