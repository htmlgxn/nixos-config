{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.brave-bookmarks-sync = {
    Unit.Description = "Copy Brave bookmarks into nixos-config repo";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/cp %h/.config/BraveSoftware/Brave-Browser/Default/Bookmarks ${config.my.repoRoot}/home/gars/dots/brave/Bookmarks";
    };
  };

  systemd.user.timers.brave-bookmarks-sync = {
    Unit.Description = "Run brave-bookmarks-sync every 24 hours";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
}
