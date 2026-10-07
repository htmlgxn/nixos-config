# nix-ld: a shim at the FHS dynamic-loader path so unpatched, dynamically
# linked binaries run on NixOS. uv-managed CPython (and every native wheel it
# loads) relies on this for libstdc++ & co. via NIX_LD_LIBRARY_PATH, which is
# scoped to those binaries instead of a session-wide LD_LIBRARY_PATH.
_: {
  programs.nix-ld.enable = true;
}
