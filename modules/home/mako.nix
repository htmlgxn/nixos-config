#
# ~/nixos-config/modules/home/mako.nix
#
# Mako configuration managed by Home Manager.
#
{...}: {
  services.mako = {
    enable = true;
    settings = {
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

      # ── Default (normal) ──────────────────────────────────────────
      background-color = "#262418";
      text-color = "#F6EEC9";
      border-color = "#826F11";
      progress-color = "over #E3C220";
    };

    extraConfig = ''
      # ── Low urgency ───────────────────────────────────────────────
      [urgency=low]
      background-color=#1E1904
      text-color=#A29C7F
      border-color=#413C1E
      default-timeout=3000

      # ── Normal urgency ────────────────────────────────────────────
      [urgency=normal]
      background-color=#262418
      text-color=#F6EEC9
      border-color=#826F11
      default-timeout=5000

      # ── High urgency (persistent) ─────────────────────────────────
      [urgency=high]
      background-color=#322F1F
      text-color=#F6EEC9
      border-color=#EF9F76
      text-color=#EF9F76
      default-timeout=0

      # ── Hidden (overflow) indicator ───────────────────────────────
      [hidden]
      format=(and %h more)
      background-color=#1E1904
      text-color=#5B5742
      border-color=#413C1E
    '';
  };
}
