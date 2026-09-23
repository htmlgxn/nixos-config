# Shared Home Manager tooling for local container and npm app workflows.
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nodejs
  ];

  my.shellAliases = {
    cdcont = "cd ${config.my.containersRoot}";
    cdquad = "cd ${config.my.containersRoot}/quadlet";
    cdcomp = "cd ${config.my.containersRoot}/compose";
    cdnpmapp = "cd ${config.my.containersRoot}/npm";
    pc = "podman compose";
  };
}
