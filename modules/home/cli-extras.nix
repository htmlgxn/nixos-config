#
# ~/nixos-config/modules/home/cli-extras.nix
#
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Extra/experimental CLI tools live here. Add new packages inside the list
  # below, and keep the x86_64 guard if they may not build on aarch64.
  #
  # Add nixpkgs packages like:
  #   pkgs.<package-name>
  #
  # Add flake inputs like:
  #   inputs.<flake>.packages.${pkgs.system}.default
  #
  # If a flake package fails tests in Nix builds, override with:
  #   (inputs.<flake>.packages.${pkgs.system}.default.overrideAttrs (_: { doCheck = false; }))
  home.packages = lib.optionals pkgs.stdenv.isx86_64 [
    (inputs.bookokrat.packages.${pkgs.system}.default.overrideAttrs (_: {doCheck = false;}))
  ];
}
