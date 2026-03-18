#
# ~/nixos-config/hosts/boreal/users.nix
#
{...}: {
  my.primaryUser = "gars";

  users.users.gars = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "render"];
    initialPassword = "changeme";
  };
}
