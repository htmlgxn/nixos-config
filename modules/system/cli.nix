#
# ~/nixos-config/modules/system/cli.nix
#
{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      Port = 2200;
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    file
    unzip
    zip
  ];
}
