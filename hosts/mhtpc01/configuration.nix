# mhtpc01 — HTPC (ThinkPad L15, AMD Ryzen 5 4500U)
# Mounted behind a 65" Samsung 4K TV, lid removed, HDMI output only.
# Input: Logitech K400 Plus via USB Unifying receiver.
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix   # Generate on device: nixos-generate-config
    ../../system/users.nix
    ../../home/home-mhtpc01.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mhtpc01";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
  users.users.tv 

  # User config: add video group for CEC device access
  users.users.felix.extraGroups = [ "video" ];

  # SSH for remote administration
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    alsa-utils
  ];

  system.stateVersion = "25.11";
}
