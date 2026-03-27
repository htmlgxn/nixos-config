# Shared system GUI base for full desktop profiles.
{
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.greetd.enable = true;

  environment.variables = {
    GTK_THEME = "Adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs.dconf.enable = true;

  fonts = {
    packages = with pkgs; [
      roboto-mono
      openmoji-color
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts.emoji = ["OpenMoji Color"];
    };
  };

  environment.systemPackages = with pkgs; [
    wayland
  ];
}
