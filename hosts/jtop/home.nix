# jtop-specific home-manager configuration for the admin user (gars).
# janine's Home Manager config lives in janine-home.nix (extraHomeUsers).
{config, ...}: {
  my.shellAliases.nrs = "nh os switch ${config.my.repoRoot} -H jtop";
}
