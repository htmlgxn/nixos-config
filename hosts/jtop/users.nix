# jtop local users: gars is the admin (SSH, rebuilds, hidden from the
# login screen); janine is the everyday desktop user without sudo.
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
    extraGroups = ["networkmanager"];
    initialPassword = "changeme";
  };

  nix.settings.trusted-users = ["root" "gars"];

  # Keep the admin account off the GDM user list so janine only sees herself.
  systemd.tmpfiles.rules = [
    "L+ /var/lib/AccountsService/users/gars - - - - ${pkgs.writeText "gars-accountsservice" ''
      [User]
      SystemAccount=true
    ''}"
  ];
}
