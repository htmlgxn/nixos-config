# Per-user baseline shared by every interactive user (gars, htmlgxn, janine):
# the shell layer, XDG base and user dirs, the home-manager CLI, and git/ssh
# client defaults. Identity (git user, SSH hosts and keys) lives in
# users/common.nix, which only gars and htmlgxn import.
{config, ...}: {
  imports = [./shell.nix];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
    };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".serverAliveInterval = 0;
  };
}
