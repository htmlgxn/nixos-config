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

    /*
      Palette reference:
        background   #1E1904   darkest base
        crust        #262418   bar background
        mantle       #322F1F   hover background
        base         #3B3724   focused backgrounds
        metal        #413C1E   subtle fills
        surface0     #5B5742   inactive/dim elements
        overlay1     #A29C7F   subdued text / inactive workspace
        text         #F6EEC9   primary text
        light-yellow #EFDD84   hover border accent
        gold-dark    #826F11   borders / dividers
        brand        #E3C220   focused accent / bright gold
        brand-bg     #E3C220   urgent backgrounds
        red          #EF8484   critical state
        orange       #EF9F76   warning state
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
        background-color: @crust;
        color: @text;
        border-top: 2px solid @gold-dark;
    }

    /* Left modules */
    #workspaces button {
        padding: 0 8px;
        color: @overlay1;
        background: transparent;
        border-right: 1px solid @gold-dark;
    }

    #workspaces button:hover {
        background: @mantle;
        color: @text;
        border-top: 2px solid @light-yellow;
    }

    #workspaces button.focused {
        background: @base;
        color: @text;
        border-top: 2px solid @brand;
    }

    #workspaces button.urgent {
        background: @brand;
        color: @background;
    }

    #workspaces button.occupied {
        color: @text;
    }

    #window {
        padding: 0 8px;
        color: @text;
    }

    #mode {
        padding: 0 8px;
        background: @brand;
        color: @background;
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
        color: @text;
        border-left: 2px solid @gold-dark;
    }

    #custom-sailscene {
        padding-right: 8px;
        padding-left: 16px;
        color: @text;
        border-left: 2px solid @gold-dark;
    }

    #custom-quebec,
    #custom-novascotia,
    #custom-code,
    #custom-browser {
        font-size: 18px;
        border-left: 2px solid @gold-dark;
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
        color: @text;
    }

    #pulseaudio.muted {
        color: @surface0;
    }

    #clock {
        color: @text;
    }

    #tray {
        padding: 0 12px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: @brand;
    }

    /* Urgent/alert states */
    #cpu.warning,
    #memory.warning {
        color: @orange;
    }

    #cpu.critical,
    #memory.critical {
        color: @red;
        background: @mantle;
    }
  '';

  colors = {
    background = "#1E1904";
    crust = "#262418";
    mantle = "#322F1F";
    base = "#3B3724";
    metal = "#413C1E";
    surface0 = "#5B5742";
    overlay1 = "#A29C7F";
    text = "#F6EEC9";
    light-yellow = "#EFDD84";
    gold-dark = "#826F11";
    brand = "#E3C220";
    brand-bg = "#E3C220";
    red = "#EF8484";
    orange = "#EF9F76";
  };
}
