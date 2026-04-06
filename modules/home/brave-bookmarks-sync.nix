{pkgs, ...}: {
  systemd.user.services.brave-bookmarks-sync = {
    Unit.Description = "Copy Brave bookmarks to ~/dev/raw-dots/brave/ and sync to git";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cp %h/.config/BraveSoftware/Brave-Browser/Default/Bookmarks %h/dev/raw-dots/brave/Bookmarks && cd %h/dev/raw-dots && ${pkgs.git}/bin/git add brave/Bookmarks && ${pkgs.git}/bin/git diff --cached --quiet || (${pkgs.git}/bin/git commit -m \"sync brave bookmarks $(date)\" && ${pkgs.git}/bin/git push origin main)'";
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
