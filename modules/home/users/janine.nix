# Home Manager user module for `janine` (desktop user on jtop).
# Same shell, aliases, CLI tools and defaults as gars (user-base.nix, plus the
# shared modules via withSharedHomeModules on the jtop host descriptor), but
# none of gars's identity: no git user, SSH hosts or SSH key from common.nix.
_: let
  userName = "janine";
in {
  imports = [../user-base.nix];

  # Repo-path aliases (cdn, ef, nr…) point at the machine's config checkout,
  # which lives in gars's home; janine can't read it, so they only resolve
  # for gars.
  my = {
    repoRoot = "/home/gars/nixos-config";
    containersRoot = "/home/gars/nixos-config/containers";
  };

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = "26.05";
  };
}
