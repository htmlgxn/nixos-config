# COSMIC desktop: cosmic-greeter login screen plus the COSMIC session. Used by
# the `cosmic` system profile (jtop).
{pkgs, ...}: {
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Kitty (installed per user by modules/home/kitty.nix) replaces COSMIC
  # Terminal.
  environment.cosmic.excludePackages = [pkgs.cosmic-term];
  xdg.terminal-exec = {
    enable = true;
    settings.COSMIC = ["kitty.desktop"];
  };
}
