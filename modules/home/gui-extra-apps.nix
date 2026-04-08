# Heavy desktop applications — opt-in, not included in lean ARM profiles.
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      # ── Video Editor ────────────────────────────────────────────────
      kdePackages.kdenlive

      # ── Misc ────────────────────────────────────────────────────────
      anarchism

      # ── CAD ─────────────────────────────────────────────────────────
      # kicad-unstable
    ]
    # ── Linux-only (not available on Darwin) ──────────────────────────
    ++ lib.optionals pkgs.stdenv.isLinux [
      # More CAD
      freecad
      # Docs
      libreoffice-fresh
    ];

  # vscode
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions =
      (with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        asvetliakov.vscode-neovim
      ])
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
      ];
  };
}
