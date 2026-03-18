# Device-specific CLI additions for the cyberdeck workflow.
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
