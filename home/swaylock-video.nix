{ pkgs, lib, ... }:
let
  video = ./assets/toyota-yaris-bouncing.mp4;

  # Monochrome, see-through indicator: hairline white ring on dark glass.
  style = lib.cli.toCommandLineShellGNU { } {
    font = "GeistMono Nerd Font";
    font-size = 14;
    indicator-radius = 90;
    indicator-thickness = 5;
    indicator-x-position = 140;
    indicator-y-position = 140;
    ignore-empty-password = true;
    hide-keyboard-layout = true;

    inside-color = "00000033";
    ring-color = "ffffff26";
    line-color = "00000000";
    separator-color = "00000000";
    text-color = "ffffffcc";
    key-hl-color = "ffffffff";
    bs-hl-color = "ffffff59";

    inside-clear-color = "00000033";
    ring-clear-color = "ffffff59";
    line-clear-color = "00000000";
    text-clear-color = "ffffff99";

    inside-ver-color = "00000059";
    ring-ver-color = "ffffffcc";
    line-ver-color = "00000000";
    text-ver-color = "ffffffff";

    inside-wrong-color = "00000080";
    ring-wrong-color = "ffffffff";
    line-wrong-color = "00000000";
    text-wrong-color = "ffffffff";

    inside-caps-lock-color = "00000033";
    ring-caps-lock-color = "ffffff80";
    line-caps-lock-color = "00000000";
    text-caps-lock-color = "ffffffcc";
    caps-lock-key-hl-color = "ffffffff";
    caps-lock-bs-hl-color = "ffffff59";
  };

  toyota-lock = pkgs.writeShellScriptBin "toyota-lock" ''
    exec ${pkgs.swaylock-plugin}/bin/swaylock-plugin --grace 5 ${style} \
      --command-each "${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio loop' '*' ${video}"
  '';
in
{
  home.packages = [ toyota-lock ];
}
