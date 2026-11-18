# jtop local users: gars is the admin (SSH, rebuilds); janine is the everyday
# desktop user without sudo. Both log into COSMIC from cosmic-greeter.
{pkgs, ...}: {
  my.primaryUser = "gars";

  users.users.gars = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "changeme";
  };

  users.users.janine = {
    isNormalUser = true;
    description = "Janine";
    shell = pkgs.nushell;
    extraGroups = ["networkmanager"];
    initialPassword = "changeme";
  };

  nix.settings.trusted-users = ["root" "gars"];
}
