#
# ~/nixos-config/modules/home/packages/go/packages.nix
#
{
  bit = {
    version = "0.3.0";
    owner = "superstarryeyes";
    repo = "bit";
    rev = "v0.3.0";
    hash = "sha256-iLwWKn8csoRkr5H8R2kpZVZCxsL0LDWHNvNoxyM6y98=";
    vendorHash = "sha256-Zxw0NyZfM42ytn+vDExLwRgNLWsdGVLC3iNVpQd8VMw=";
    subPackages = ["cmd/bit"];
    modVendor = true;
  };
  cull = {
    version = "0.6.1";
    owner = "legostin";
    repo = "cull";
    rev = "v0.6.1";
    hash = "sha256-F5DLpYaSktumgoXalKbO7fJjr3Mv/myYoTivvGaoYNY=";
    vendorHash = "sha256-1qfkALCIV6ikih0QpAxOXVzTFeRK9AxMbI99WYTlYeA=";
    modVendor = true;
  };
}
