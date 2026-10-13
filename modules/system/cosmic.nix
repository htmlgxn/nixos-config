# COSMIC desktop: cosmic-greeter login screen plus the COSMIC session. Used by
# the `cosmic` system profile (jtop-cosmic, a trial alongside GNOME).
{pkgs, ...}: {
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Kitty (installed per user by modules/home/kitty.nix) replaces COSMIC
  # Terminal, as GNOME Console is replaced on the gnome profile.
  environment.cosmic.excludePackages = [pkgs.cosmic-term];
  xdg.terminal-exec = {
    enable = true;
    settings.COSMIC = ["kitty.desktop"];
  };
}
