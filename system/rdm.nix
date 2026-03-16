{ pkgs, ... }:

let
  rdm-unwrapped = pkgs.stdenv.mkDerivation rec {
    pname = "remote-desktop-manager";
    version = "2026.1.0.8";

    src = pkgs.fetchurl {
      url = "https://cdn.devolutions.net/download/Linux/RDM/${version}/RemoteDesktopManager_${version}_amd64.deb";
      hash = "sha256-OT+uu/IPunewVAk/qLX09C4QAWwQdRS7ghSAlAJQAZo=";
    };

    nativeBuildInputs = [ pkgs.dpkg ];

    dontPatchELF = true;
    dontStrip = true;

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      mkdir -p $out
      cp -r usr/lib/devolutions/RemoteDesktopManager $out/lib
      cp -r usr/share $out/share

      # Fix desktop file
      substituteInPlace $out/share/applications/com.devolutions.remotedesktopmanager.desktop \
        --replace-fail "Exec=remotedesktopmanager" "Exec=rdm"
    '';
  };

  rdm = pkgs.buildFHSEnv {
    name = "rdm";
    targetPkgs = pkgs: with pkgs; [
      # .NET / CoreCLR
      stdenv.cc.cc.lib

      # GTK and rendering
      gtk3
      glib
      gdk-pixbuf
      pango
      cairo
      atk
      at-spi2-atk
      at-spi2-core
      harfbuzz

      # WebKit (RDM depends on libwebkit2gtk-4.1)
      webkitgtk_4_1

      # VTE terminal
      vte

      # Crypto / TLS
      openssl
      icu

      # X11/Wayland support
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXcursor
      xorg.libXi
      xorg.libxcb
      xorg.libICE
      xorg.libSM
      xwayland

      # Mesa / GPU
      mesa
      libglvnd
      vulkan-loader

      # Audio
      alsa-lib
      libpulseaudio

      # Misc native deps
      libsecret
      gnome-keyring
      dbus
      fontconfig
      freetype
      zlib
      libdrm
      libxkbcommon
      nspr
      nss
      cups
      expat
      libsoup_3
      lttng-ust
      libgcrypt
    ];

    runScript = pkgs.writeShellScript "rdm-wrapper" ''
      export GDK_BACKEND=x11
      export DOTNET_EnableWriteXorExecute=0
      export LD_LIBRARY_PATH="${rdm-unwrapped}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec ${rdm-unwrapped}/lib/RemoteDesktopManager "$@"
    '';

    extraInstallCommands = ''
      mkdir -p $out/share
      ln -s ${rdm-unwrapped}/share/applications $out/share/applications
      ln -s ${rdm-unwrapped}/share/icons $out/share/icons
    '';

    meta = {
      description = "Devolutions Remote Desktop Manager";
      homepage = "https://devolutions.net/remote-desktop-manager/";
      platforms = [ "x86_64-linux" ];
    };
  };

in
{
  environment.systemPackages = [ rdm ];
}
