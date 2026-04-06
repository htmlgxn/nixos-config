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
    inherit (borgCfg) paths;
    repo = borgCfg.repoPath;
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat %d/${credName}";
    };
    compression = "auto,zstd";
    inherit (borgCfg) startAt;
    inherit user;
    inherit (borgCfg) exclude;

    prune.keep = {
      inherit (borgCfg.keep) daily;
      inherit (borgCfg.keep) weekly;
      inherit (borgCfg.keep) monthly;
      inherit (borgCfg.keep) yearly;
    };

    extraCreateArgs = [
      "--stats"
      "--checkpoint-interval"
      "600"
    ];
  };

  systemd.services.borgbackup-job-home = {
    unitConfig.RequiresMountsFor = [borgCfg.repoPath];
    serviceConfig.LoadCredential = "${credName}:${credPath}";
  };
}
