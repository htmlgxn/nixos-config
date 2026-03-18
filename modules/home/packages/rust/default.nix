#
# ~/nixos-config/modules/home/packages/rust/default.nix
#
# =============================================================================
# RUST TOOLCHAIN & CUSTOM CRATES
# =============================================================================
# Rust programming language toolchain and custom crates from crates.io.
#
# Includes:
#   - Rust compiler (rustc), cargo, rustfmt, clippy
#   - Custom crates defined in crates.nix (built with OpenSSL support)
#
# TO ADD RUST TOOLS:
#
# Option 1 - From nixpkgs:
#   home.packages = with pkgs; [ cargo-edit cargo-watch ];
#
# Option 2 - Custom from crates.io (using crates.nix):
#   1. Add to crates.nix:
#      mytool = {
#        pname = "mytool";
#        version = "0.1.0";
#        crateHash = "sha256-...";
#        cargoHash = "sha256-...";
#      };
#   2. Rebuild to get the hashes (it will fail with expected hashes)
#   3. Update with correct hashes
#
# TO FIND HASHES:
#   Run `nix build` - it will fail and show the expected crateHash/cargoHash.
#   OpenSSL is linked externally (not vendored) for all crates.
# =============================================================================
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
