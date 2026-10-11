# Brave with the shared extension set. The package is pkgs.brave, so each
# output's overlays decide the build (nightly on boreal, stable elsewhere).
_: {
  programs.brave = {
    enable = true;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "aapbdbdomjkkjkaonfhkkikfgjllcleb";} # Google Translate
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # SponsorBlock (YouTube)
      {id = "cclelndahbckbenkjhflpdbgdldlbecc";} # Get cookies.txt LOCALLY
      {id = "bhlhnicpbhignbdhedgjhgdocnmhomnp";} # ColorZilla
      {id = "ilehaonighjijnmpnagapkhpcdbhclfg";} # Grass Lite Node
    ];
  };
}
