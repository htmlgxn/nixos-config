{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.brave-bookmarks-sync = {
    Unit.Description = "Copy Brave bookmarks to ~/dev/raw-dots/brave/";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/cp %h/.config/BraveSoftware/Brave-Browser/Default/Bookmarks %h/dev/raw-dots/brave/Bookmarks";
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
