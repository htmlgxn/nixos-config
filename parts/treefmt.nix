# parts/treefmt.nix
#
# Unified formatting via treefmt-nix.
# Run `nix fmt` to format the entire repo.
# Run `nix fmt -- --check` to check without modifying.
{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {pkgs, ...}: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        # ── Nix ──────────────────────────────────────────────────────
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;

        # ── Lua ──────────────────────────────────────────────────────
        stylua.enable = true;

        # ── Shell ────────────────────────────────────────────────────
        shfmt.enable = true;

        # ── Markdown / YAML / JSON ───────────────────────────────────
        prettier = {
          enable = true;
          includes = [
            "*.md"
            "*.yaml"
            "*.yml"
            "*.json"
          ];
        };
      };

      settings.formatter = {
        # Exclude generated hardware configs from nix formatters
        alejandra.excludes = ["hosts/*/hardware-configuration.nix"];
        deadnix.excludes = ["hosts/*/hardware-configuration.nix"];
        statix.excludes = ["hosts/*/hardware-configuration.nix"];
      };
    };
  };
}
