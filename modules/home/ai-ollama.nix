# Generic Ollama runtime selection.
{
  lib,
  pkgs,
  ...
}: {
  my.ollamaPackage = lib.mkDefault pkgs.ollama;
}
