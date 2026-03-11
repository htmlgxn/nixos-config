{ config, pkgs, ... }:

{
  home.username = "htmlgxn";
  home.homeDirectory = "/home/htmlgxn";

  home.packages = with pkgs; [
    htop
    tree
    ripgrep
    fd
  ];

  programs.bash = {
    enable = true;

    shellAliases = {
      c = "clear";
      h = "history";
      la = "ls -a";
      lsa = "ls -a";
      ll = "ls -la";
      lsla = "ls -la";
      lsal = "ls -la";
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
      calc = "fend";
      cdc = "cd ~/nixos-config";
      ef = "nvim ~/nixos-config/flake.nix";
      eh = "nvim ~/nixos-config/home/htmlgxn/home.nix";
      econfn = "nvim ~/nixos-config/hosts/nixos-vm/configuration.nix"; 
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config/.#nixos-vm";
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
