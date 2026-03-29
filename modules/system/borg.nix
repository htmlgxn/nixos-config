# BorgBackup service module driven by host-provided `my.borg.*` values.
#
# The passphrase is stored in /root/borg-passphrase (mode 0400, root-only).
# The systemd service reads it via LoadCredential, so the backup user never
# has direct access to the file.
{
  config,
  pkgs,
  lib,
  ...
}: let
  borgCfg = config.my.borg;
  user = config.my.primaryUser;
  credName = "borg-passphrase";
  credPath = "/root/${credName}";
in {
  assertions = [
    {
      assertion = borgCfg.repoPath != "";
      message = "Set my.borg.repoPath in the host configuration before enabling the borg module.";
    }
  ];

  environment.systemPackages = [pkgs.borgbackup];

  services.borgbackup.jobs.home = {
    paths = borgCfg.paths;
    repo = borgCfg.repoPath;
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat %d/${credName}";
    };
    compression = "auto,zstd";
    startAt = borgCfg.startAt;
    user = user;
    exclude = borgCfg.exclude;

    prune.keep = {
      daily = borgCfg.keep.daily;
      weekly = borgCfg.keep.weekly;
      monthly = borgCfg.keep.monthly;
      yearly = borgCfg.keep.yearly;
    };

    extraCreateArgs = [
      "--stats"
      "--checkpoint-interval" "600"
    ];
  };

  systemd.services.borgbackup-job-home = {
    unitConfig.RequiresMountsFor = [borgCfg.repoPath];
    serviceConfig.LoadCredential = "${credName}:${credPath}";
  };
}
