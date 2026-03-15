#
# ~/nixos-config/modules/home/waybar-settings.nix
#
# Shared Waybar settings (used by sway + niri).
#

{ config, ... }:

let
  cfgDir = config.xdg.configHome;
  waybarDotDir = ../../home/gars/dots/waybar;
in
{
  style = builtins.readFile "${waybarDotDir}/style.css";

  common = {
    layer = "top";
    position = "bottom";
    height = 24;
    spacing = 4;

    "modules-right" = [
      "custom/browser"
      "custom/disks"
      "disk"
      "pulseaudio"
      "memory"
      "cpu"
      "custom/quebec"
      "clock"
      "tray"
      "network"
    ];

    "custom/quebec" = {
      exec = "cat ${cfgDir}/waybar/assets/quebec_emoji.txt";
      format = "{}";
      tooltip = false;
    };

    "custom/browser" = {
      format = "🌐";
      "on-click" = "brave";
    };

    "custom/disks" = {
      exec = "${cfgDir}/waybar/scripts/disks.sh";
      interval = 30;
      format = "{}";
      tooltip = false;
    };

    disk = {
      interval = 30;
      format = "root[/] ﹫ {percentage_used}%";
      path = "/";
      tooltip = true;
      "tooltip-format" = "{used} used of {total} ({free} free)";
    };

    pulseaudio = {
      format = "{icon} / vol {volume}%";
      "format-muted" = "🔇 / muted";
      "format-icons" = {
        default = [ "🔈" "🔉" "🔉" "🔊" ];
      };
      "on-click" = "pavucontrol";
      "scroll-step" = 5;
    };

    memory = {
      interval = 2;
      format = "ram {percentage}%";
      tooltip = true;
      "tooltip-format" = "{used:0.1f}G used of {total:0.1f}G";
    };

    cpu = {
      interval = 2;
      format = "cpu {usage}%";
      tooltip = false;
    };

    network = {
      interface = "enp6s0";
      "format-ethernet" = "모 {ipaddr}";
      "format-disconnected" = "enp6s0 disconnected";
      interval = 5;
      tooltip = true;
      "tooltip-format-ethernet" = "{ifname} {ipaddr}/{cidr}\n↑ {bandwidthUpBytes} ↓ {bandwidthDownBytes}";
    };

    clock = {
      interval = 1;
      format = "{:%U.%w / %Y.%m.%d / %T}";
      "format-alt" = "{:%a / %B %d / %I:%M}";
      tooltip = false;
    };

    tray = {
      spacing = 8;
      "icon-size" = 16;
    };
  };
}
