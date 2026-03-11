{ config, pkgs, ... }:

{
  home.username = "htmlgxn";
  home.homeDirectory = "/home/htmlgxn";

  home.packages = with pkgs; [
    htop
    tree
    ripgrep
    fd
    glow
  ];

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/htmlgxn/nixos-config/home/htmlgxn/nvim";

  programs.bash = {

    enable = true;

    shellAliases = {
      c = "clear";
      h = "history";
      la = "ls -a";
      ll = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
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
      eh = "nvim ~/nixos-config/home/htmlgxn/home.nix";
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
