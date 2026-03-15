#
# ~/nixos-config/modules/home/cli-extras.nix
#
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages =
    # Experimental or host-specific CLI tools live here.
    lib.optionals pkgs.stdenv.isx86_64 [
      inputs.bookokrat.packages.${pkgs.system}.default
    ];
}
