# Home Manager user module for `janine` (desktop user on jtop).
# Secondary users get only this module plus their home profile; the shared
# gars toolkit (nixvim, containers, CLI baseline) is not applied.
_: let
  userName = "janine";
in {
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = "26.05";
  };
}
