final: prev: {
  brave = prev.stdenv.mkDerivation (finalAttrs: {
    pname = "brave-browser-nightly";
    # DO NOT edit version/sha256 manually — managed by scripts/update-brave-nightly.sh
    version = "1.99.16";

    src = prev.fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${finalAttrs.version}/brave-browser-nightly_${finalAttrs.version}_amd64.deb";
      sha256 = "sha256-w053iG68kxP7E1AzCyuKncyKwaN6FTHn6vr0mwEsVPA=";
    };

    nativeBuildInputs = [prev.dpkg prev.makeWrapper prev.patchelf];

    dontConfigure = true;
    dontBuild = true;

    # Build the library path for the wrapper
    rpath = prev.lib.makeLibraryPath [
      prev.stdenv.cc.cc.lib
      prev.glib
      prev.gtk3
      prev.pango
      prev.cairo
      prev.gdk-pixbuf
      prev.harfbuzz
      prev.freetype
      prev.fontconfig
      prev.dbus
      prev.libGL
      prev.libdrm
      prev.libxkbcommon
      prev.at-spi2-atk
      prev.nspr
      prev.nss
      prev.alsa-lib
      prev.cups
      prev.systemd
      prev.expat
      prev.libuuid
      prev.libx11
      prev.libxcomposite
      prev.libxdamage
      prev.libxext
      prev.libxfixes
      prev.libxrandr
      prev.libxcb
      prev.libxtst
      prev.libxshmfence
      prev.libgbm
      prev.libglvnd
      prev.mesa
      prev.vulkan-loader
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out $out/bin

      # Extract contents from the .deb structure
      cp -R usr/share $out
      cp -R opt $out

      # The nightly wrapper script and binary paths
      WRAPPER=$out/opt/brave.com/brave-nightly/brave-browser-nightly
      BINARY=$out/opt/brave.com/brave-nightly/brave

      # Fix bash path in the wrapper script
      substituteInPlace $WRAPPER \
        --replace-fail /bin/bash ${final.stdenv.shell}

      # Patch the binary with correct RPATH
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
               --set-rpath "$rpath" \
               $BINARY

      # Create wrapper with proper library path
      makeWrapper $BINARY $out/bin/brave \
        --set LD_LIBRARY_PATH "$rpath" \
        --set CHROME_WRAPPER brave \
        --prefix PATH : "${prev.lib.makeBinPath [prev.xdg-utils prev.coreutils]}"

      # Fix desktop file paths (newer debs also ship a hidden reverse-DNS
      # com.brave.Browser.nightly.desktop alongside the classic one)
      for desktop in $out/share/applications/*.desktop; do
        substituteInPlace "$desktop" \
          --replace-quiet /usr/bin/brave-browser-nightly brave
      done
      grep -q '^Exec=brave' $out/share/applications/brave-browser-nightly.desktop

      # Fix default apps XML path
      substituteInPlace $out/share/gnome-control-center/default-apps/brave-browser-nightly.xml \
        --replace-fail /opt/brave.com/brave-nightly $out/opt/brave.com/brave-nightly

      # Set up icons. The desktop files use Icon=brave-browser-nightly; the
      # logos are product_logo_<N>_nightly.png (product_logo_<N>.png in older
      # debs). brave-browser.png is kept for anything using the old name.
      for icon in 16 24 32 48 64 128 256; do
        dir=$out/share/icons/hicolor/''${icon}x''${icon}/apps
        for logo in product_logo_''${icon}_nightly.png product_logo_''${icon}.png; do
          src=$out/opt/brave.com/brave-nightly/$logo
          if [ -f "$src" ]; then
            mkdir -p "$dir"
            ln -s "$src" "$dir/brave-browser-nightly.png"
            ln -s "$src" "$dir/brave-browser.png"
            break
          fi
        done
      done
      [ -e $out/share/icons/hicolor/256x256/apps/brave-browser-nightly.png ]

      runHook postInstall
    '';

    meta = {
      description = "Brave Browser Nightly - Early preview of new features";
      homepage = "https://brave.com";
      license = prev.lib.licenses.mpl20;
      platforms = ["x86_64-linux"];
    };
  });
}
