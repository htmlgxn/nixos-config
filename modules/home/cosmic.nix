# COSMIC for non-technical users, mirroring modules/home/gnome.nix: COSMIC's
# default top panel + bottom dock, kitty (my.terminal) as the terminal on
# Super+T and Ctrl+Alt+T, settings managed through cosmic-manager (written with
# cosmic-ctl, so COSMIC Settings can still change them). Dock pins are per host.
{
  config,
  inputs,
  ...
}: let
  terminalAction = {
    __type = "enum";
    variant = "Terminal";
  };
in {
  imports = [
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
    ./terminal-theme.nix
    ./kitty.nix
  ];

  wayland.desktopManager.cosmic = {
    enable = true;

    # COSMIC's "Terminal" system action (Super+T) runs kitty.
    systemActions = {
      __type = "map";
      value = [
        {
          key = terminalAction;
          value = config.my.terminal;
        }
      ];
    };

    shortcuts = [
      {
        key = "Ctrl+Alt+T";
        action = {
          __type = "enum";
          variant = "System";
          value = [terminalAction];
        };
      }
    ];
  };
}
