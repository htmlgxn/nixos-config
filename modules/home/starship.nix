# Starship cross-shell prompt.
_: {
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };
}
