# Home Manager user module for `janine` (desktop user on jtop).
# Same shell, aliases and CLI tools as gars (the shared modules come from
# withSharedHomeModules on the jtop host descriptor), but none of gars's
# identity: no git user, SSH hosts or generated SSH key from common.nix.
_: let
  userName = "janine";
in {
  imports = [../shell.nix];

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
