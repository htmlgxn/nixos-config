#
# ~/nixos-config/modules/home/flatpak/packages.nix
#
# =============================================================================
# FLATPAK APPLICATIONS
# =============================================================================
# List of Flatpak applications installed for the user.
# These are sandboxed desktop applications from Flathub.
#
# TO ADD APPLICATIONS:
#   1. Find the Flatpak ID at https://flathub.org
#   2. Add to the list below: "org.example.App"
#   3. Rebuild: nrs (or appropriate rebuild command)
#
# Examples:
#   "org.gimp.GIMP"         - GIMP image editor
#   "org.mozilla.firefox"   - Firefox browser (if not using Nix package)
#   "com.spotify.Client"    - Spotify
#
# Note: Flatpak apps are automatically updated on rebuild.
# =============================================================================
#
[
  "org.gimp.GIMP"
  "org.dune3d.dune3d"
  # "org.mozilla.firefox"
]
