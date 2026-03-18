# boreal local users and primary-user value.
{...}: {
  my.primaryUser = "gars";

  users.users.gars = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "render"];
    initialPassword = "changeme";
  };
}
