# Packaged update-brave-nightly.sh with its runtime dependencies.
# `nix` itself is taken from the caller's PATH so it matches the system's Lix.
{
  writeShellApplication,
  coreutils,
  curl,
  git,
  gnused,
  jq,
}:
writeShellApplication {
  name = "update-brave-nightly";
  runtimeInputs = [coreutils curl git gnused jq];
  text = builtins.readFile ./update-brave-nightly.sh;
}
