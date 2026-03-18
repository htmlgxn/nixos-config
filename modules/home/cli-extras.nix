#
# ~/nixos-config/modules/home/cli-extras.nix
#
# =============================================================================
# EXTRA CLI PACKAGES (GARSPERSONAL/EXPERIMENTAL)
# =============================================================================
# Extra/experimental CLI tools for user 'gars'.
# Used when you want packages separate from the main cli.nix list.
#
# TO ADD PACKAGES:
#   Add to the list inside `lib.optionals pkgs.stdenv.isx86_64 [ ... ]`
#
#   For nixpkgs packages:
#     pkgs.<package-name>
#
#   For flake inputs:
#     inputs.<flake>.packages.${pkgs.system}.default
#
#   If a flake package fails tests in Nix builds:
#     (inputs.<flake>.packages.${pkgs.system}.default.overrideAttrs (_: { doCheck = false; }))
#
# TO CREATE FOR ANOTHER USER:
#   1. Copy this file to cli-extras-<username>.nix
#   2. Update the hmCLIExtras_<username> definition in flake.nix
# =============================================================================
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
