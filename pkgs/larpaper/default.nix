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

    # The scripts locate each other via `$(dirname "$BASH_SOURCE")` and prefer a
    # `.sh` sibling, falling back to the extensionless name. Installing them
    # side by side under the bare names makes that fallback resolve inside the
    # store, so no path rewriting is needed for sibling lookup.
    install -Dm755 larpaper.sh        "$out/bin/larpaper"
    install -Dm755 launch-larpaper.sh "$out/bin/launch-larpaper"
    install -Dm755 larpaper-idle.sh   "$out/bin/larpaper-idle"
    install -Dm755 larpaper-all.sh    "$out/bin/larpaper-all"
    install -Dm755 larpaper-toggle.sh "$out/bin/larpaper-toggle"

    # DELIBERATELY NOT installed into $out/bin: larpaper.conf and art.txt.
    # Each script does:
    #     repo_config="$script_dir/larpaper.conf"
    #     [[ -r "$repo_config" ]] && config_file="$repo_config" \
    #                             || config_file="$installed_config"
    # A conf file next to the binaries would therefore win over
    # ~/.config/larpaper/larpaper.conf and make the config permanently
    # read-only in the store. Keeping $out/bin free of it preserves the
    # user-config path. Ship the defaults as reference material instead.
    install -Dm644 larpaper.conf "$out/share/larpaper/larpaper.conf"

    # Default artwork is the NixOS logo. Sourced from fastfetch's ascii logo,
    # with its `$1`/`$2` colour placeholders stripped — those are a fastfetch
    # convention, not ANSI, so tte would render them literally as text. They
    # occupy no display width, so removing them preserves the alignment.
    install -Dm644 ${./art-nixos.txt} "$out/share/larpaper/art.txt"
    install -Dm644 art.txt            "$out/share/larpaper/art-upstream.txt"

    # quick-setup and uninstall-larpaper.sh are intentionally dropped: Nix owns
    # installation and removal, and both would write into ~/.local/bin.

    runHook postInstall
  '';

  postPatch = ''
    # Multi-monitor launcher, maintained alongside this derivation rather than
    # patched into upstream's single-window launch-larpaper.
    cp ${./larpaper-all.sh} larpaper-all.sh
    cp ${./larpaper-toggle.sh} larpaper-toggle.sh
    chmod +w larpaper-all.sh larpaper-toggle.sh

    # Pin the interpreter and give every script a closed runtime PATH, so none
    # of them depend on what happens to be in the user's environment.
    for script in larpaper.sh launch-larpaper.sh larpaper-idle.sh larpaper-all.sh \
                  larpaper-toggle.sh; do
      substituteInPlace "$script" \
        --replace-fail '#!/usr/bin/env bash' '#!${bashExe}
export PATH="${runtimePath}''${PATH:+:$PATH}"'
    done

    # Keep the self-identification patterns consistent with the pinned shebang:
    # argv[0] is now the absolute bash path, not the bare word "bash", so the
    # original `^bash ` anchor would never match. Without this, launch-larpaper
    # loses its duplicate-instance guard and larpaper-idle's `resume` action
    # fails to terminate the screensaver.
    substituteInPlace launch-larpaper.sh larpaper-idle.sh \
      --replace-fail '^bash $larpaper' '^${bashExe} $larpaper'
  '';

  # Regenerated rather than patched: the shipped larpaper-idle.desktop carries
  # `OnlyShowIn=KDE;`, which makes spec-compliant autostart implementations skip
  # it under XDG_CURRENT_DESKTOP=Hyprland. Only the launcher entry is kept here;
  # start the idle watcher from the compositor or a systemd user unit instead.
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
    license = lib.licenses.mit; # TODO(human): confirm against upstream LICENSE
    platforms = lib.platforms.linux;
    mainProgram = "launch-larpaper";
  };
})
