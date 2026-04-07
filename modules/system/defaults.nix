# Shared NixOS host defaults applied to every host via sharedSystemModules.
{
  pkgs,
  config,
  ...
}: {
  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://yazi.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };
  # ── Default login shell ──────────────────────────────────────────
  users.users.${config.my.primaryUser}.shell = pkgs.nushell;
  environment.shells = with pkgs; [nushell bashInteractive];
}
