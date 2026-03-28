#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-dark/waybar.nix
#
# Waybar CSS theme: gars-yellow-dark
#
{
  css = ''
    /* ==============================================
       Waybar — gars-yellow theme
       ============================================== */

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
        background-color: #262418;
        color: #F6EEC9;
        border-top: 2px solid #826F11;
    }

    /* Left modules */
    #workspaces button {
        padding: 0 8px;
        color: #A29C7F;
        background: transparent;
        border-right: 1px solid #826F11;
    }

    #workspaces button:hover {
        background: #322F1F;
        color: #F6EEC9;
        border-top: 2px solid #EFDD84;
    }

    #workspaces button.focused {
        background: #3B3724;
        color: #F6EEC9;
        border-top: 2px solid #E3C220;
    }

    #workspaces button.urgent {
        background: #E3C220;
        color: #1E1904;
    }

    #workspaces button.occupied {
        color: #F6EEC9;
    }

    #window {
        padding: 0 8px;
        color: #F6EEC9;
    }

    #mode {
        padding: 0 8px;
        background: #E3C220;
        color: #1E1904;
        font-weight: bold;
    }

    /* Separator between modules */
    #custom-disks,
    #custom-keyboard-layout,
    #disk,
    #pulseaudio,
    #memory,
    #cpu,
    #network,
    #clock,
    #tray {
        padding: 0 8px;
        color: #F6EEC9;
        border-left: 2px solid #826F11;
    }

    #custom-sailscene {
        padding-right: 8px;
        padding-left: 16px;
        color: #F6EEC9;
        border-left: 2px solid #826F11;
    }

    #custom-quebec,
    #custom-novascotia,
    #custom-code,
    #custom-browser {
        font-size: 18px;
        border-left: 2px solid #826F11;
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
        color: #E3C220;
    }

    #pulseaudio.muted {
        color: #5B5742;
    }

    #clock {
        color: #F6EEC9;
    }

    #tray {
        padding: 0 12px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #E3C220;
    }

    /* Urgent/alert states */
    #cpu.warning,
    #memory.warning {
        color: #E08850;
    }

    #cpu.critical,
    #memory.critical {
        color: #E06060;
        background: #322F1F;
    }
  '';

  colors = {
    brand = "#E3C220";
    text = "#F6EEC9";
    gold-dark = "#826F11";
    orange = "#E08850";
    red = "#E06060";
  };
}
