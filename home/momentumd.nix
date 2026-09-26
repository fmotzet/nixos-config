{ pkgs, lib, ... }:
let
  # Daemon + CLI for Sennheiser Momentum headphones (ANC, transparency, battery, ...)
  momentumd = pkgs.rustPlatform.buildRustPackage {
    pname = "momentumd";
    version = "0.1.0-unstable-2026-09-11";

    src = pkgs.fetchFromGitHub {
      owner = "Jazden";
      repo = "momentumd";
      rev = "889b951d2753e04849b3edc9da805ec34566776e";
      hash = "sha256-epjnqqxKVZa1gvUeWUKBMCKxuOHuXQi5jXrzaEVg3uA=";
    };

    cargoHash = "sha256-TGZ+WtKq8WTBhy/s7hvvW/NC8rN1iROWpHyqo7t0S1Y=";

    # Momentum 5 exposes GAIA on RFCOMM channels 11/12, which upstream doesn't probe
    postPatch = ''
      substituteInPlace src/bt.rs \
        --replace-fail 'COMMON_CHANNELS: [u8; 4] = [2, 1, 14, 15]' \
                       'COMMON_CHANNELS: [u8; 6] = [11, 12, 2, 1, 14, 15]'
    '';

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.dbus ];
  };
in
{
  home.packages = [ momentumd ];
}
