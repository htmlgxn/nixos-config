# jtop-specific home-manager configuration for the admin user (gars). The
# desktop itself (apps, dock, idle, night light) is shared with janine in
# desktop.nix.
{config, ...}: {
  imports = [./desktop.nix];

  my.shellAliases.nrs = "nh os switch ${config.my.repoRoot} -H jtop";
}
