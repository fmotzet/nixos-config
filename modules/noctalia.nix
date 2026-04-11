{ pkgs, noctalia, ... }:
{
  environment.systemPackages = [
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}