# boreal-specific home-manager configuration.
# Included automatically for every boreal output via hostHomeModules in flake.nix.
{pkgs, ...}: {
  # boreal connects to itself — use localhost instead of boreal.local.
  my.borealHost = "localhost";

  # AMD ROCm variant for local AI inference.
  my.ollamaPackage = pkgs.ollama-rocm;

  # ── Boreal desktop defaults ──────────────────────────────────────
  my.dualKeyboardLayout = true;
  my.showRootDisk = true;
  my.terminal = "kitty";

  # ── Boreal shell aliases (shared across shells) ───────────────────
  programs.bash = {
    shellAliases = {
      # ── Boreal host shortcuts ────────────────────────────────────────
      nrs = "nh os switch . -H boreal";
      nrtty = "nh os switch . -H boreal-tty";

      # ── Mount navigation ─────────────────────────────────────────────
      cdarch = "cd /mnt/archive";
      cdsea = "cd /mnt/seagate6";
      cdevo = "cd /mnt/evo";
    };
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  programs.nushell = {
    shellAliases = {
      # ── Boreal host shortcuts ────────────────────────────────────────
      nrs = "nh os switch . -H boreal";
      nrtty = "nh os switch . -H boreal-tty";

      # ── Mount navigation ─────────────────────────────────────────────
      cdarch = "cd /mnt/archive";
      cdsea = "cd /mnt/seagate6";
      cdevo = "cd /mnt/evo";
    };
    extraConfig = ''
      # Add Boreal-specific commands

    '';
    environmentVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  programs.ssh.matchBlocks."rpi4" = {
    hostname = "rpi4.local";
    port = 2200;
    user = "gars";
    addressFamily = "inet";
    identityFile = "~/.ssh/id_ed25519";
    identitiesOnly = true;
  };

  # ── Systemd user services ─────────────────────────────────────────
  systemd.user = {
    services = {
      brave-bookmarks-sync = {
        Unit.Description = "Copy Brave bookmarks to ~/dev/raw-dots/brave/ and sync to git";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cp %h/.config/BraveSoftware/Brave-Browser/Default/Bookmarks %h/dev/raw-dots/brave/Bookmarks && cd %h/dev/raw-dots && ${pkgs.git}/bin/git add brave/Bookmarks && ${pkgs.git}/bin/git diff --cached --quiet || (${pkgs.git}/bin/git commit -m \"sync brave bookmarks $(date)\" && ${pkgs.git}/bin/git push origin main)'";
        };
      };

      update-brave-nightly = {
        Unit = {
          Description = "Update Brave Nightly overlay and rebuild";
          After = ["network-online.target"];
          Wants = ["network-online.target"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash %h/nixos-config/scripts/update-brave-nightly.sh";
          ExecStartPost = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake %h/nixos-config#boreal";
          Restart = "no";
        };
      };
    };

    timers = {
      brave-bookmarks-sync = {
        Unit.Description = "Run brave-bookmarks-sync every 24 hours";
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };
        Install.WantedBy = ["timers.target"];
      };

      update-brave-nightly = {
        Unit.Description = "Daily timer for Brave Nightly update";
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "10min";
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
