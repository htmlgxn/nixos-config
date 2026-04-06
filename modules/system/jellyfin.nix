# Jellyfin service module driven by host-provided `my.jellyfin.*` values.
{
  config,
  pkgs,
  lib,
  ...
}: let
  jellyfinCfg = config.my.jellyfin;
  aclRules =
    lib.concatMap
    (path: [
      "A ${path} - - - - u:jellyfin:rx"
      "A ${path} - - - - d:u:jellyfin:rx"
    ])
    jellyfinCfg.mediaRoots;
in {
  assertions = [
    {
      assertion = jellyfinCfg.dataDir != "";
      message = "Set my.jellyfin.dataDir in the host configuration before enabling the Jellyfin module.";
    }
  ];

  services.jellyfin = {
    enable = true;
    package = pkgs.jellyfin;

    # Open port 8096 (firewall rules to be added separately)
    openFirewall = false;

    # User/group configuration
    user = "jellyfin";
    group = "jellyfin";

    # Data directory off root partition
    inherit (jellyfinCfg) dataDir;
  };

  # Create Jellyfin data directory with correct ownership
  # and transcode directory (tmpfs will mount over it)
  systemd.tmpfiles.rules =
    [
      "d /var/lib/jellyfin/transcodes 0750 jellyfin jellyfin - -"
    ]
    ++ aclRules;

  # Mount tmpfs for transcodes (4GB limit, RAM-based)
  systemd.mounts = [
    {
      what = "tmpfs";
      where = "/var/lib/jellyfin/transcodes";
      type = "tmpfs";
      options = "size=${jellyfinCfg.transcodeSize},mode=0750,uid=jellyfin,gid=jellyfin";
      wantedBy = ["jellyfin.service"];
      before = ["jellyfin.service"];
    }
  ];

  systemd.services.jellyfin.serviceConfig = lib.mkIf (jellyfinCfg.vaDriver != "") {
    Environment = [
      "LIBVA_DRIVER_NAME=${jellyfinCfg.vaDriver}"
    ];
  };

  systemd.services.jellyfin.preStart = ''
    install -d -m 0755 -o jellyfin -g jellyfin ${jellyfinCfg.dataDir}
    install -d -m 0750 -o jellyfin -g jellyfin ${jellyfinCfg.dataDir}/config
    install -d -m 0750 -o jellyfin -g jellyfin ${jellyfinCfg.dataDir}/cache
    install -d -m 0750 -o jellyfin -g jellyfin ${jellyfinCfg.dataDir}/data
    install -d -m 0750 -o jellyfin -g jellyfin ${jellyfinCfg.dataDir}/log
  '';

  systemd.services.jellyfin.unitConfig = {
    RequiresMountsFor = [jellyfinCfg.dataDir] ++ jellyfinCfg.mediaRoots;
  };

  # Hardware acceleration (AMD RX 570)
  hardware.graphics.enable = true;
}
