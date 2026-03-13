#
# ~/nixos-config/modules/home/gui-base.nix
#
# Common GUI packages for non-sway compositors.
# No dotfile symlinks here — each compositor manages its own config.
# Used by: COSMIC, Hyprland, Niri, River, Wayfire, LabWC.
#

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty      # terminal
    fuzzel         # launcher
    waybar         # bar (used by non-COSMIC compositors)
    mako           # notifications
    wlsunset       # blue light filter
    grim           # screenshot
    flameshot      # GUI screenshot tool
    brave          # browser
    thunar         # file manager
    wl-clipboard   # wl-copy / wl-paste
  ];

  # No dotfile symlinks — add compositor-specific ones in a dedicated
  # module (e.g. modules/home/hyprland-home.nix) as you build out configs.
}
