#
# ~/nixos-config/modules/home/waybar-settings.nix
#
# Shared Waybar settings (used by sway + niri).
#

{ pkgs, ... }:

let
  disksScript = pkgs.writeShellScript "waybar-disks" ''
    #!/usr/bin/env bash
    # disks.sh — Waybar custom module for free/total per disk
    # Uses Pango markup instead of Polybar color tags

    PRIMARY="#E3C220"
    FOREGROUND="#F6EEC9"
    DISABLED="#826F11"

    human() {
      numfmt --to=iec --suffix=B --format="%.1f" "$1" | tr '[:upper:]' '[:lower:]'
    }

    output=""
    for disk in $(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print $1}'); do
      size=$(lsblk -bndo SIZE /dev/$disk)
      parts=$(lsblk -lnpo NAME,TYPE /dev/$disk | awk '$2=="part"{print $1}')
      free=0
      total=0
      for p in $parts; do
        mp=$(lsblk -no MOUNTPOINT "$p")
        if [ -n "$mp" ] && mountpoint -q -- "$mp"; then
          read -r avail size <<EOF
    $(df -B1 --output=avail,size "$mp" 2>/dev/null | tail -1)
    EOF
          free=$((free + avail))
          total=$((total + size))
        fi
      done
      if [ "$total" -gt 0 ]; then
        output+="[<span color='${PRIMARY}'>${disk}</span>]<span color='${FOREGROUND}'>$(human $free)/$(human $total)</span> "
      else
        output+="<span color='${PRIMARY}'>${disk}</span> <span color='${DISABLED}'>--</span>/<span color='${FOREGROUND}'>$(human $size)</span>  "
      fi
    done

    printf '%s\n' "$output"
  '';
in
{
  style = ''
    /* ==============================================
       Waybar — gars-yellow theme
       ============================================== */

    /*
      Palette reference:
        background  #1E1904   darkest base
        crust       #262418   bar background
        mantle      #322F1F   hover background
        base        #3B3724   focused background
        metal       #413C1E   subtle fills
        surface0    #5B5742   inactive/dim elements
        overlay1    #A29C7F   subdued text / inactive workspace
        text        #F6EEC9   primary text
        light-yellow #EFDD84  hover border accent
        gold-dark   #826F11   borders / dividers
        brand       #E3C220   focused accent / bright gold
        brand-bg    #E3C220   urgent backgrounds
        red         #EF8484   critical state
        orange      #EF9F76   warning state
    */

    * {
        font-family: "Roboto Mono", "OpenMoji Color";
        font-size: 13px;
        letter-spacing: 0px;
        min-height: 0;
        border: none;
        border-radius: 0;
        padding: 0;
        margin: 0;
    }

    window#waybar {
        background-color: #262418;       /* crust */
        color: #F6EEC9;                  /* text */
        border-top: 2px solid #826F11;   /* gold-dark */
    }

    /* Left modules */
    #workspaces button {
        padding: 0 12px;
        color: #A29C7F;                  /* overlay1 — inactive workspace label */
        background: transparent;
        border-right: 1px solid #826F11; /* gold-dark divider */
    }

    #workspaces button:hover {
        background: #322F1F;             /* mantle */
        color: #F6EEC9;                  /* text */
        border-top: 2px solid #EFDD84;   /* light-yellow accent */
    }

    #workspaces button.focused {
        background: #3B3724;             /* base */
        color: #F6EEC9;                  /* text */
        border-top: 2px solid #E3C220;   /* brand gold */
    }

    #workspaces button.urgent {
        background: #E3C220;         /* brand gold */
        color: #1E1904;              /* background — dark text on bright bg */
    }

    #workspaces button.occupied {
        color: #F6EEC9;              /* text */
    }

    #window {
        padding: 0 8px;
        color: #F6EEC9;              /* text */
    }

    #mode {
        padding: 0 8px;
        background: #E3C220;         /* brand gold */
        color: #1E1904;              /* background */
        font-weight: bold;
    }

    /* Separator between modules */
    #custom-disks,
    #disk,
    #pulseaudio,
    #memory,
    #cpu,
    #network,
    #clock,
    #tray {
        padding: 0 8px;
        color: #F6EEC9;              /* text */
        border-left: 2px solid #826F11; /* gold-dark */
    }

    #custom-sailscene {
        padding-right: 8px;
        padding-left: 16px;
        color: #F6EEC9;              /* text */
        border-left: 2px solid #826F11; /* gold-dark */
    }

    #custom-quebec,
    #custom-novascotia,
    #custom-code,
    #custom-browser {
        font-size: 18px;
        border-left: 2px solid #826F11; /* gold-dark */
    }

    #custom-quebec,
    #custom-novascotia {
        padding-right: 8px;
        padding-left: 10px;
    }

    #custom-code,
    #custom-browser {
        padding-right: 8px;
        padding-left: 12px;
    }

    /* Module label prefixes */
    #pulseaudio,
    #memory,
    #cpu,
    #network {
        color: #F6EEC9;              /* text */
    }

    #pulseaudio.muted {
        color: #5B5742;              /* surface0 — dimmed when muted */
    }

    #clock {
        color: #F6EEC9;              /* text */
    }

    #tray {
        padding: 0 12px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #E3C220;   /* brand gold */
    }

    /* Urgent/alert states */
    #cpu.warning,
    #memory.warning {
        color: #EF9F76;              /* orange — warning */
    }

    #cpu.critical,
    #memory.critical {
        color: #EF8484;              /* red — critical */
        background: #322F1F;         /* mantle */
    }
  '';

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
      exec = "printf '%s' '⚜️🏴⚜️'";
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
