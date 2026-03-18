#
# ~/nixos-config/modules/home/cli-cyberdeck.nix
#
# =============================================================================
# CYBERDECK-SPECIFIC CLI PACKAGES
# =============================================================================
# Packages specific to the cyberdeck device (aarch64).
# Currently tested on boreal-tty-cyberdeck before deploying to actual hardware.
#
# TO ADD PACKAGES:
#   Add to `home.packages = with pkgs; [ ... ]` below
#
# TO OVERRIDE UV TOOLS:
#   Set `uvTools.packages = [ "tool1" "tool2" ];` below
#   This overrides modules/home/packages/python/uv-tools.nix for cyberdeck only.
#
# NOTES:
#   - Some packages may not be available on aarch64
#   - Test on boreal-tty-cyberdeck first: `nrtty-cyberdeck`
#   - For architecture-specific guards, use:
#       lib.optionals pkgs.stdenv.isAarch64 [ ... ]
#
# TO CREATE FOR ANOTHER DEVICE:
#   1. Copy this file to cli-<devicename>.nix
#   2. Add HM config in flake.nix:
#        hmCLI_<Devicename>_<user> = mkHm "<user>" [ ./modules/home/cli-<devicename>.nix ];
#   3. Use in NixOS config:
#        <host>-<device> = mkTTY_x86 "<host>" hmCLI_<Devicename>_<user>;
# =============================================================================
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Override uv tools for cyberdeck (replaces uv-tools.nix list)
  uvTools.packages = [
    "contact"
    # Add more cyberdeck-specific uv tools here
  ];

  home.packages = with pkgs; [
    # Add cyberdeck-specific packages here
  ];
}
