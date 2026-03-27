# Shared NixOS host defaults applied to every host via sharedSystemModules.
{...}: {
  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
