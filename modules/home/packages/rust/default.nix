# Rust toolchain (via fenix) and custom crates from crates.io (via crane).
{
  pkgs,
  inputs,
  ...
}: let
  # ── Toolchain ─────────────────────────────────────────────────────
  # Pin a specific stable toolchain, independent of nixpkgs' rustc.
  # This prevents surprise compiler crashes on nixpkgs updates.
  system = pkgs.stdenv.hostPlatform.system;

  fenix = inputs.fenix.packages.${system};

  toolchain = fenix.stable.toolchain;
  # Or for a minimal footprint:
  # toolchain = fenix.combine [
  #   fenix.stable.rustc
  #   fenix.stable.cargo
  #   fenix.stable.rustfmt
  #   fenix.stable.clippy
  # ];

  # ── Crane ─────────────────────────────────────────────────────────
  craneLib = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;

  crates = import ./crates.nix;

  # Build a single crate from crates.io.
  mkCratePkg = pname: {
    version,
    crateHash,
    cargoHash,
    doCheck ? false,
    extraBuildInputs ? [],
    ...
  }:
    craneLib.buildPackage {
      inherit pname version doCheck;

      src = pkgs.fetchCrate {
        inherit pname version;
        hash = crateHash;
      };

      cargoVendorDir = craneLib.vendorCargoDeps {
        src = pkgs.fetchCrate {
          inherit pname version;
          hash = crateHash;
        };
        cargoHash = cargoHash;
      };

      nativeBuildInputs = [pkgs.pkg-config];
      buildInputs = [pkgs.openssl] ++ extraBuildInputs;
      OPENSSL_NO_VENDOR = 1;
    };

  builtCrates = builtins.mapAttrs mkCratePkg crates;
in {
  home.packages =
    [toolchain]
    ++ builtins.attrValues builtCrates;
}
