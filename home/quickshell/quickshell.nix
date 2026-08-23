{ config, ... }:
{
  programs.quickshell.enable = true;

  xdg.configFile."quickshell/felix".source =
    config.lib.file.mkOutOfStoreSymlink "/home/felix/nixos-config/home/quickshell";
}
