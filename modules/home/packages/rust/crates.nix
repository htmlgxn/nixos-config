#
# ~/nixos-config/modules/home/packages/rust/crates.nix
#
{
  "outside" = {
    version = "0.5.0";
    crateHash = "sha256-9qTW6xuLYwuNw3cahGdK6zXua8Qpu+NyIRjqsTAmsZI=";
    cargoHash = "sha256-60wgt3/wJ+2lFQN+k2ev0KLSRxiFdxpHtnWILZfHQw0=";
  };
  "diskonaut-ng" = {
    version = "0.13.2";
    crateHash = "sha256-3FrdcJxImYpyn5jyJrZF4Haj0JKXNPlrLwIK8A02s1M=";
    cargoHash = "sha256-+NwZbR3fRj8Wi95GtsUQFWOyaZ0ekC4chsoJ5rsH3Zg=";
  };
  "domain-check" = {
    version = "1.0.1";
    crateHash = "sha256-z4UNTVGLnSLW9gyg4d9xWpLgNhl45rLlK9ARA/YMz3Y=";
    cargoHash = "sha256-KJR/WmSyv4v9ZLEFc/ksVGT3pMBeqAjKZBnvVoP30yk=";
    doCheck = false;
  };
}
