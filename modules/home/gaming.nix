# Lightweight Home Manager gaming additions.
# For system-level gaming support (Steam, Proton), see modules/system/gaming.nix
# Add user-level gaming packages here (e.g., launchers, utilities)
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Add gaming home packages here
  ];
}
