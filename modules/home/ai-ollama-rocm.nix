# Ollama ROCm override for supported AMD Linux systems.
{pkgs, ...}: {
  my.ollamaPackage = pkgs.ollama-rocm;
}
