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
    shell = pkgs.nushell;
    extraGroups = ["networkmanager"];
    initialPassword = "changeme";
  };

  nix.settings.trusted-users = ["root" "gars"];

  # Keep the admin account off the GDM user list so janine only sees herself.
  # Must be a real, writable file: accounts-daemon chmods everything in this
  # directory and exits on a read-only store symlink, which takes GDM down.
  systemd.tmpfiles.rules = [
    "f+ /var/lib/AccountsService/users/gars 0600 root root - [User]\\nSystemAccount=true\\n"
  ];
}
