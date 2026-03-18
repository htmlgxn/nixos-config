#
# ~/nixos-config/modules/home/packages/default.nix
#
# =============================================================================
# LANGUAGE TOOLCHAINS & PACKAGES
# =============================================================================
# Language-specific toolchains and packages for development.
# Imported by hmSharedImports for all users.
#
# Includes:
#   - Go (toolchain + custom tools from crates.nix)
#   - Rust (toolchain + custom crates from crates.nix)
#   - Python (toolchain + uv tools)
#
# TO ADD LANGUAGE PACKAGES:
#   1. Create directory: modules/home/packages/<language>/
#   2. Create default.nix with package definitions
#   3. Add to imports list below
#
# Each language directory should export `home.packages` for its toolchain.
# =============================================================================
#
{...}: {
  imports = [
    ./go
    ./rust
    ./python
  ];
}
