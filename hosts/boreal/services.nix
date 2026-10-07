# boreal service-local values consumed by shared modules.
{lib, ...}: let
  softServeData = "/mnt/archive/soft-serve";
in {
  imports = [
    ../../modules/system/soft-serve.nix
    ../../modules/system/borg.nix
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
      SOFT_SERVE_DATA_PATH = lib.mkForce softServeData;
      SOFT_SERVE_INITIAL_ADMIN_KEYS = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPyzf/Oy8OFx6SK4wxhIgwyzMEXu8tso01ZpfS3WngG";
    };
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "soft-serve";
      Group = lib.mkForce "soft-serve";
      # Upstream points this at /var/lib/soft-serve/repos (hooks must be
      # executable); that path doesn't exist when the data lives on archive.
      ExecPaths = lib.mkForce "${softServeData}/repos";
    };
  };

  my.borg = let
    home = "/home/gars";
  in {
    repoPath = "/mnt/archive/backup/gars";
    paths = [
      "${home}/dev"
      "${home}/videos"
      "${home}/downloads"
      "${home}/pictures"
      "${home}/documents"
      "${home}/archive"
      "${home}/music"
      "${home}/.config"
      "${home}/.claude"
      "${home}/.codex"
      "${home}/.qwen"
      "${home}/.gemini"
      "${home}/.ssh"
    ];
    exclude = [
      "*/node_modules"
      "*/.direnv"
      "*/result"
      "*/__pycache__"
      "*/.venv"
      "*.pyc"
      "*/.cache"
    ];
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
