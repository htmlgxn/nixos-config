#
# ~/nixos-config/overlays/kitty-launchservices.nix
#
# Darwin-only: keep kitty's app bundle launchable by LaunchServices without an
# exec() hop, so tiling window managers can see it.
#
# nixpkgs wraps the real binary as Contents/MacOS/.kitty-wrapped and puts a
# makeBinaryWrapper stub at Contents/MacOS/kitty (it only appends imagemagick /
# ncurses to PATH). Since macOS 27, when LaunchServices starts a bundle and the
# bundle executable immediately execve()s a different image, the process loses
# its LaunchServices registration: NSRunningApplication reports
# processIdentifier == -1 even though the process is alive. AeroSpace (like
# yabai) enumerates apps through NSWorkspace and keys everything on the pid, so
# kitty never gets registered and its windows are never tiled — they just sit
# where macOS put them, looking like floating windows.
#
# Fix: restore the unwrapped binary as CFBundleExecutable and move the wrapper's
# only job into Info.plist's LSEnvironment, which LaunchServices applies without
# an exec. $out/bin/kitty stays a real wrapper — CLI launches are unaffected by
# the macOS 27 change, and keeping it there preserves the PATH suffix for them.
#
final: prev: let
  inherit (prev) lib;
in
  lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
    kitty = prev.kitty.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          app="$out/Applications/kitty.app/Contents"
          pathSuffix="$out/bin:${
            lib.makeBinPath [
              final.imagemagick
              final.ncurses.dev
            ]
          }"

          # $out/bin/kitty is a symlink to the in-bundle wrapper; break it so the
          # CLI entry point survives unwrapping the bundle.
          rm "$out/bin/kitty"
          mv "$app/MacOS/.kitty-wrapped" "$app/MacOS/kitty"
          makeBinaryWrapper "$app/MacOS/kitty" "$out/bin/kitty" \
            --suffix PATH : "$pathSuffix"

          # LaunchServices-started kitty inherits none of that PATH, so declare it.
          substituteInPlace "$app/Info.plist" \
            --replace-fail \
              '<key>KITTY_LAUNCHED_BY_LAUNCH_SERVICES</key>' \
              '<key>PATH</key><string>'"$pathSuffix"':/usr/bin:/bin:/usr/sbin:/sbin</string><key>KITTY_LAUNCHED_BY_LAUNCH_SERVICES</key>'
        '';
    });
  }
