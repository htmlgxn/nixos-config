#
# ~/nixos-config/modules/home/waybar-settings.nix
#
# Shared Waybar settings (used by sway + niri + hyprland).
# Colors are imported from shared gui-theme.nix.
#
{
  pkgs,
  config,
  ...
}: let
  lib = pkgs.lib;
  theme = config.my.guiThemeData.waybar;
  disksScript = pkgs.writeShellScript "waybar-disks" ''
        #!/usr/bin/env bash
        # disks.sh — Waybar custom module for free/total per disk
        # Uses Pango markup instead of Polybar color tags

        human() {
          ${pkgs.coreutils}/bin/numfmt --to=iec --suffix=B --format="%.1f" "$1" | ${pkgs.coreutils}/bin/tr '[:upper:]' '[:lower:]'
        }

        PRIMARY="${theme.colors.orange}"
        FOREGROUND="${theme.colors.text}"
        DISABLED="${theme.colors.gold-dark}"
        output=""
        for disk in $(${pkgs.util-linux}/bin/lsblk -ndo NAME,TYPE | ${pkgs.gawk}/bin/awk '$2=="disk"{print $1}'); do
          size=$(${pkgs.util-linux}/bin/lsblk -bndo SIZE /dev/$disk)
          parts=$(${pkgs.util-linux}/bin/lsblk -lnpo NAME,TYPE /dev/$disk | ${pkgs.gawk}/bin/awk '$2=="part"{print $1}')
          free=0
          total=0
          for p in $parts; do
            mp=$(${pkgs.util-linux}/bin/lsblk -no MOUNTPOINT "$p")
            if [ -n "$mp" ] && ${pkgs.util-linux}/bin/mountpoint -q -- "$mp"; then
              read -r avail size <<EOF
    $(${pkgs.coreutils}/bin/df -B1 --output=avail,size "$mp" 2>/dev/null | ${pkgs.coreutils}/bin/tail -1)
    EOF
              free=$((free + avail))
              total=$((total + size))
            fi
          done
          if [ "$total" -gt 0 ]; then
            output+="[<span color='$PRIMARY'>$disk</span>]<span color='$FOREGROUND'>$(human "$free")/$(human "$total")</span> "
          else
            output+="<span color='$PRIMARY'>$disk</span> <span color='$DISABLED'>--</span>/<span color='$FOREGROUND'>$(human "$size")</span>  "
          fi
        done

        printf '%s\n' "$output"
  '';
  keyboardLayoutScript = pkgs.writeShellScript "waybar-kbd-layout" ''
    #!/usr/bin/env bash

    layout="$(${pkgs.sway}/bin/swaymsg -t get_inputs -r 2>/dev/null \
      | ${pkgs.jq}/bin/jq -r '
        map(select(.type == "keyboard"))
        | map(.xkb_active_layout_name // empty)
        | map(select(length > 0))
        | .[0] // empty
      ')"

    case "$layout" in
      *Graphite*)
        printf 'gr\n'
        ;;
      "")
        printf '--\n'
        ;;
      *)
        printf 'us\n'
        ;;
    esac
  '';
  quebecText = ../../home/gars/dots/waybar/quebec.txt;
in {
  style = theme.css;

  common = {
    layer = "top";
    position = "bottom";
    height = 24;
    spacing = 4;

    "modules-right" =
      [
        "custom/browser"
        "custom/disks"
      ]
      ++ lib.optionals config.my.dualKeyboardLayout [
        "custom/keyboard-layout"
        "disk"
      ]
      ++ [
        "pulseaudio"
        "memory"
        "cpu"
        "custom/quebec"
        "clock"
        "tray"
        "network"
      ];

    "custom/quebec" = {
      exec = "${pkgs.coreutils}/bin/cat ${quebecText}";
      interval = 3600;
      format = "{}";
      tooltip = false;
    };

    "custom/browser" = {
      format = "🌐";
      "on-click" = "brave";
    };

    "custom/disks" = {
      exec = "${disksScript}";
      interval = 30;
      format = "{}";
      tooltip = false;
    };

    "custom/keyboard-layout" = {
      exec = "${keyboardLayoutScript}";
      interval = 1;
      format = "kbd {}";
      tooltip = false;
      "on-click" = "${pkgs.sway}/bin/swaymsg input type:keyboard xkb_switch_layout next";
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
        default = ["🔈" "🔉" "🔉" "🔊"];
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
      interface = config.my.networkInterface;
      "format-ethernet" = "모 {ipaddr}";
      "format-disconnected" = "${config.my.networkInterface} disconnected";
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
