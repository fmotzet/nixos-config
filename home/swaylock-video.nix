{ pkgs, ... }:
let
  video = ./assets/toyota-yaris-bouncing.mp4;

  toyota-lock = pkgs.writeShellScriptBin "toyota-lock" ''
    exec ${pkgs.swaylock-plugin}/bin/swaylock-plugin --grace 5 \
      --command-each "${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio loop' '*' ${video}"
  '';
in
{
  home.packages = [ toyota-lock ];
}
