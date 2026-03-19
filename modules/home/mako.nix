#
# ~/nixos-config/modules/home/mako.nix
#
# Mako configuration managed by Home Manager.
# Colors are imported from shared gui-theme.nix.
#
{config, ...}: let
  theme = config.my.guiThemeData.mako;
in {
  services.mako = {
    enable = true;
    settings =
      theme.default
      // {
        # ── Layout ────────────────────────────────────────────────────
        sort = "-time";
        layer = "overlay";
        anchor = "top-right";
        margin = 12;
        padding = "10,14";
        width = 320;
        height = 150;
        border-size = 1;
        border-radius = 0;
        icons = true;
        max-icon-size = 32;
        icon-path = "/usr/share/icons/AdwaitaLegacy/";
        markup = true;
        actions = true;
        history = true;
        default-timeout = 5000;
        ignore-timeout = 0;
        max-visible = 5;

        # ── Font ──────────────────────────────────────────────────────
        font = "Roboto Mono 11";
      }
      // theme.urgency;
  };
}
