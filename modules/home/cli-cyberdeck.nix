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
# TO ADD UV TOOLS:
#   1. Add to `cyberdeckUvTools` list below
#   2. Tools are auto-installed on rebuild
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
}: let
  # Cyberdeck-specific uv tools
  cyberdeckUvTools = [
    "contact"
    # Add more cyberdeck-specific uv tools here
  ];
in {
  home.packages = with pkgs; [
    # Add cyberdeck-specific packages here
  ];

  # Install cyberdeck-specific uv tools
  home.activation.installCyberdeckUvTools = lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    for tool in ${lib.concatStringsSep " " cyberdeckUvTools}; do
      echo "uv: (re)installing $tool for cyberdeck..."
      ${pkgs.uv}/bin/uv tool install "$tool" --force \
        --python ${pkgs.python314}/bin/python3
    done
  '';
}
