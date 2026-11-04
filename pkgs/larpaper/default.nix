{ lib
, stdenvNoCC
, bash
, coreutils
, procps
, util-linux
, kitty
, terminaltexteffects
, swayidle
, makeDesktopItem
, copyDesktopItems
}:

let
  bashExe = lib.getExe' bash "bash";

  # Everything the three scripts shell out to at runtime.
  #   larpaper.sh        -> tte, swayidle, stty, sleep, dirname
  #   launch-larpaper.sh -> kitty, pgrep
  #   larpaper-idle.sh   -> flock, swayidle, pkill
  runtimePath = lib.makeBinPath [
    bash
    coreutils            # stty, sleep, dirname
    procps               # pgrep, pkill
    util-linux           # flock
    kitty
    terminaltexteffects  # provides the `tte` binary
    swayidle
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "larpaper";
  version = "0-unstable-2026-08-14";

  src = ./larpaper-quick-setup.tar.gz;

  nativeBuildInputs = [ copyDesktopItems ];

  dontConfigure = true;
  dontBuild = true;

  # patchShebangs would rewrite `#!/usr/bin/env bash` to an absolute interpreter
  # on its own, but it runs inside fixupPhase where its result is awkward to
  # predict. The scripts match their own process with `pgrep -f "^bash ..."`,
  # whose anchor depends on the exact argv[0] the shebang produces, so the
  # interpreter is pinned here instead and the match patterns are rewritten to
  # agree with it (see postPatch).
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 larpaper.sh        "$out/bin/larpaper"
    install -Dm755 launch-larpaper.sh "$out/bin/launch-larpaper"
    install -Dm755 larpaper-idle.sh   "$out/bin/larpaper-idle"
    install -Dm755 larpaper-all.sh    "$out/bin/larpaper-all"
    install -Dm755 larpaper-toggle.sh "$out/bin/larpaper-toggle"

    install -Dm644 larpaper.conf "$out/share/larpaper/larpaper.conf"

    install -Dm644 ${./art-nixos.txt} "$out/share/larpaper/art.txt"
    install -Dm644 art.txt            "$out/share/larpaper/art-upstream.txt"

    # quick-setup and uninstall-larpaper.sh are intentionally dropped: Nix owns
    # installation and removal, and both would write into ~/.local/bin.

    runHook postInstall
  '';

  postPatch = ''
    cp ${./larpaper-all.sh} larpaper-all.sh
    cp ${./larpaper-toggle.sh} larpaper-toggle.sh
    chmod +w larpaper-all.sh larpaper-toggle.sh

    for script in larpaper.sh launch-larpaper.sh larpaper-idle.sh larpaper-all.sh \
                  larpaper-toggle.sh; do
      substituteInPlace "$script" \
        --replace-fail '#!/usr/bin/env bash' '#!${bashExe}
export PATH="${runtimePath}''${PATH:+:$PATH}"'
    done
    substituteInPlace launch-larpaper.sh larpaper-idle.sh \
      --replace-fail '^bash $larpaper' '^${bashExe} $larpaper'
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "larpaper";
      desktopName = "Larpaper";
      comment = "Terminal Text Effects screensaver";
      exec = "launch-larpaper";
      icon = "utilities-terminal";
      terminal = false;
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Fullscreen terminal screensaver built on Kitty, tte and swayidle";
    homepage = "https://github.com/2i60/larpaper";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "launch-larpaper";
  };
})
