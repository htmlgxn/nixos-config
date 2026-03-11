#
# ~/nixos-config/home/gars/home.nix
#

{ config, pkgs, ... }:

{
  home.username = "gars";
  home.homeDirectory = "/home/gars";

  # home.packages = with pkgs; [
  #   add user-specific pkgs here
  #   ...
  # ];

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/nvim";

  programs.bash = {

    enable = true;

    shellAliases = {
      c = "clear";
      h = "history";
      la = "ls -a";
      ll = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      mkdir = "mkdir -pv";
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      edit = "nvim";
      e = "nvim";
      ga = "git add .";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      cdc = "cd ~/nixos-config";
      ef = "nvim ~/nixos-config/flake.nix";
      eh = "nvim ~/nixos-config/home/gars/home.nix";
      ecli = "nvim ~/nixos-config/modules/home/cli.nix";
      egui = "nvim ~/nixos-config/modules/home/gui.nix";
      econfn = "nvim ~/nixos-config/hosts/nixos-vm/configuration.nix"; 
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config/.#nixos-vm";
      nrsg = "sudo nixos-rebuild switch --flake ~/nixos-config/.#nixos-vm-gui";
      calc = "fend";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    bashrcExtra = ''
      # manually add to .bashrc here
    '';

    profileExtra = ''
      # manually add to .bash_profile here
    '';
  };

  home.stateVersion = "25.11";
}
