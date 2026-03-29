final: prev: {
  brave = prev.stdenv.mkDerivation (finalAttrs: {
    pname = "brave-browser-nightly";
    # DO NOT edit version/sha256 manually — managed by scripts/update-brave-nightly.sh
    version = "1.90.79";

    src = prev.fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${finalAttrs.version}/brave-browser-nightly_${finalAttrs.version}_amd64.deb";
      sha256 = "sha256-PIdbxBWQQZ8eVXyOB5VumRfaarAcVpG1Bli68tNxqF8=";
    };

    nativeBuildInputs = [ prev.dpkg prev.makeWrapper prev.patchelf ];

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
        --prefix PATH : "${prev.lib.makeBinPath [ prev.xdg-utils prev.coreutils ]}"

      # Fix desktop file paths
      substituteInPlace $out/share/applications/brave-browser-nightly.desktop \
        --replace-fail /usr/bin/brave-browser-nightly brave

      # Fix default apps XML path
      substituteInPlace $out/share/gnome-control-center/default-apps/brave-browser-nightly.xml \
        --replace-fail /opt/brave.com/brave-nightly $out/opt/brave.com/brave-nightly

      # Set up icons
      for icon in 16 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/$iconx$icon/apps
        if [ -f $out/opt/brave.com/brave-nightly/product_logo_$icon.png ]; then
          ln -s $out/opt/brave.com/brave-nightly/product_logo_$icon.png $out/share/icons/hicolor/$iconx$icon/apps/brave-browser.png
        fi
      done

      runHook postInstall
    '';

    meta = {
      description = "Brave Browser Nightly - Early preview of new features";
      homepage = "https://brave.com";
      license = prev.lib.licenses.mpl20;
      platforms = [ "x86_64-linux" ];
    };
  });
}
