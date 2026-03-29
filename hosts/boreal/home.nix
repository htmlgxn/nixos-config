# boreal-specific home-manager configuration.
# Included automatically for every boreal output via hostHomeModules in flake.nix.
{
  config,
  pkgs,
  ...
}: {
  # boreal connects to itself — use localhost instead of boreal.local.
  my.borealHost = "localhost";

  programs.ssh.matchBlocks."rpi4" = {
    hostname = "rpi4.local";
    port = 2200;
    user = "gars";
    addressFamily = "inet";
    identityFile = "~/.ssh/id_ed25519";
    identitiesOnly = true;
  };

  # Brave Nightly auto-update timer
  systemd.user.services.update-brave-nightly = {
    Unit = {
      Description = "Update Brave Nightly overlay and rebuild";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/nixos-config/scripts/update-brave-nightly.sh";
      ExecStartPost = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake %h/nixos-config#boreal";
      Restart = "no";
    };
  };

  systemd.user.timers.update-brave-nightly = {
    Unit.Description = "Daily timer for Brave Nightly update";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "10min";
    };
    Install.WantedBy = ["timers.target"];
  };
}
