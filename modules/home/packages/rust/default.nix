#
# ~/nixos-config/modules/home/packages/rust/default.nix
#
{pkgs, ...}: let
  crates = import ./crates.nix;

  # Helper for building Rust packages from crates.io with OpenSSL
  mkRustPackage = {
    pname,
    version,
    crateHash,
    cargoHash,
    doCheck ? false,
    ...
  } @ attrs:
    pkgs.rustPlatform.buildRustPackage (attrs
      // {
        src = pkgs.fetchCrate {
          inherit pname version;
          hash = crateHash;
        };
        inherit cargoHash doCheck;
        nativeBuildInputs = [pkgs.pkg-config];
        buildInputs = [pkgs.openssl];
        OPENSSL_NO_VENDOR = 1;
      });

  builtCrates =
    builtins.mapAttrs
    (pname: attrs: mkRustPackage ({inherit pname;} // attrs))
    crates;
in {
  home.packages = with pkgs;
    [
      # ── Toolchain ────────────────────────────────────────────────────
      rustc
      cargo
      rustfmt
      clippy

      # ── Custom Tools ────────────────────────────────────────────────
    ]
    ++ builtins.attrValues builtCrates;
}
