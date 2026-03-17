#
# ~/nixos-config/modules/home/cli-cyberdeck.nix
#
# Cyberdeck-specific CLI packages.
# Currently empty - add packages here for testing on boreal-tty-cyberdeck before deploying to cyberdeck.
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Add cyberdeck-specific packages here
  ];
}
