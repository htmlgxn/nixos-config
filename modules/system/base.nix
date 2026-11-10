# Baseline for every NixOS output: locale, login shells and the system-level
# nh (rebuild helper + store cleanup). Included via sharedSystemModules in
# parts/inventory.nix.
{
  pkgs,
  config,
  ...
}: {
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  documentation.nixos.enable = false;
  users.users.${config.my.primaryUser}.shell = pkgs.nushell;
  environment.shells = with pkgs; [nushell bashInteractive];

  # System-level nh: `nh clean all` also prunes system generations, which
  # the Home Manager `nh clean user` timer never touches. The per-user timer
  # is forced off for NixOS outputs in parts/lib.nix (mkOutput).
  programs.nh = {
    enable = true;
    flake = "/home/${config.my.primaryUser}/nixos-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 3";
    };
  };
}
