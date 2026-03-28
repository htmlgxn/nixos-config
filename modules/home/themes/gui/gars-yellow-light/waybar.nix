#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-light/waybar.nix
#
# Waybar CSS theme: gars-yellow-light
#
{
  css = ''
    /* ==============================================
       Waybar — gars-yellow-light theme
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
        background-color: #c4be86;
        color: #1e1a06;
        border-top: 2px solid #6b5a0a;
    }

    /* Left modules */
    #workspaces button {
        padding: 0 8px;
        color: #8a8460;
        background: transparent;
        border-right: 1px solid #6b5a0a;
    }

    #workspaces button:hover {
        background: #d8d2a2;
        color: #1e1a06;
        border-top: 2px solid #f5e070;
    }

    #workspaces button.focused {
        background: #d8d2a2;
        color: #1e1a06;
        border-top: 2px solid #c9aa10;
    }

    #workspaces button.urgent {
        background: #b85010;
        color: #e2dcb0;
    }

    #workspaces button.occupied {
        color: #1e1a06;
    }

    #window {
        padding: 0 8px;
        color: #1e1a06;
    }

    #mode {
        padding: 0 8px;
        background: #c9aa10;
        color: #e2dcb0;
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
        color: #1e1a06;
        border-left: 2px solid #6b5a0a;
    }

    #custom-sailscene {
        padding-right: 8px;
        padding-left: 16px;
        color: #1e1a06;
        border-left: 2px solid #6b5a0a;
    }

    #custom-quebec,
    #custom-novascotia,
    #custom-code,
    #custom-browser {
        font-size: 18px;
        border-left: 2px solid #6b5a0a;
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
        color: #c9aa10;
    }

    #pulseaudio.muted {
        color: #cdc79a;
    }

    #clock {
        color: #1e1a06;
    }

    #tray {
        padding: 0 12px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #c9aa10;
    }

    /* Urgent/alert states */
    #cpu.warning,
    #memory.warning {
        color: #b85010;
    }

    #cpu.critical,
    #memory.critical {
        color: #b83030;
        background: #f5f0d5;
    }
  '';

  colors = {
    brand = "#c9aa10";
    text = "#1e1a06";
    gold-dark = "#6b5a0a";
    orange = "#b85010";
    red = "#b83030";
  };
}
