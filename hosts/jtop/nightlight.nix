# Night light on jtop. COSMIC has none built in, and its compositor lacks
# wlr-gamma-control, so wlsunset can't work there. cosmic-nightlight instead
# runs a root helper (through pkexec) that briefly switches VT, writes the
# gamma ramps over DRM and switches back, so each change flickers for 1-2 s.
#
# Upstream only lets wheel/sudo members use it without a password, and the app
# won't apply anything on its own (at login, after resume) for anyone else.
# gars is in wheel; janine is not an admin, so she gets a `nightlight` group
# instead: a polkit rule for the helper, and a patch adding the group to the
# app's list. The helper only ever writes colour curves, so this gives her
# nothing else.
#
# The fixed temperature for both users lives in nightlight-home.nix.
{
  inputs,
  pkgs,
  ...
}: let
  package =
    inputs.cosmic-nightlight.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
    (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace crates/cosmic-nightlight/src/backend.rs \
            --replace-fail \
              'const PASSWORDLESS_GROUPS: [&str; 2] = ["sudo", "wheel"];' \
              'const PASSWORDLESS_GROUPS: [&str; 3] = ["sudo", "wheel", "nightlight"];'
        '';
    });
in {
  imports = [inputs.cosmic-nightlight.nixosModules.default];

  programs.cosmic-nightlight = {
    enable = true;
    inherit package;
  };

  users.groups.nightlight = {};
  users.users.janine.extraGroups = ["nightlight"];

  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
        if (
            action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "${package}/libexec/cosmic-nightlight-helper" &&
            subject.isInGroup("nightlight")
        ) {
            return polkit.Result.YES;
        }
    });
  '';

  # The package's background scheduler (a user unit), started with every COSMIC
  # session (gars and janine). It re-applies the tint after resume and at
  # login. It runs `pkexec` by name, and the unit's PATH must reach the setuid
  # wrapper.
  systemd.user.services.cosmic-nightlight = {
    wantedBy = ["graphical-session.target"];
    path = ["/run/wrappers"];
  };
}
