# Rust toolchain (via fenix) and custom crates from crates.io (via crane).
{
  pkgs,
  inputs,
  ...
}: let
  # ── Toolchain ─────────────────────────────────────────────────────
  # Pin a specific stable toolchain, independent of nixpkgs' rustc.
  # This prevents surprise compiler crashes on nixpkgs updates.
  inherit (pkgs.stdenv.hostPlatform) system;

  fenix = inputs.fenix.packages.${system};

  # Explicit components instead of fenix.stable.toolchain (the "complete"
  # profile), which also pulls ~1 GB of rust-docs plus llvm-tools and friends.
  toolchain = fenix.combine (with fenix.stable; [
    rustc
    cargo
    rustfmt
    clippy
    rust-src
    rust-analyzer
  ]);

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
        inherit cargoHash;
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
