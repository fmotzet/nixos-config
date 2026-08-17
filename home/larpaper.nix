# Home Manager module for larpaper.
{ pkgs, ... }:
let
  larpaper = pkgs.callPackage ../pkgs/larpaper { };
in
{
  home.packages = [ larpaper ];
  xdg.configFile."larpaper/larpaper.conf".source =
    "${larpaper}/share/larpaper/larpaper.conf";
  xdg.configFile."larpaper/art.txt".source =
    "${larpaper}/share/larpaper/art.txt";
}
