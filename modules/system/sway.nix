# Sway system profile.
{pkgs, ...}: {
  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd sway";
      user = "greeter";
    };
  };

  environment.variables = {
    GTK_THEME = "Adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    wlr.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
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
    xwayland
    wofi
  ];
}
