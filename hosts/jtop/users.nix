# jtop local users: gars is the admin (SSH, rebuilds); janine is the everyday
# desktop user without sudo. cosmic-greeter lists every uid >= 1000 account,
# so gars still shows on the login screen.
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
