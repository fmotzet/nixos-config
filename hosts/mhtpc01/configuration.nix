# mhtpc01 — HTPC (ThinkPad L15, AMD Ryzen 5 4500U)
# Mounted behind a 65" Samsung 4K TV, lid removed, HDMI output only.
# Input: Logitech K400 Plus via USB Unifying receiver.
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix   # Generate on device: nixos-generate-config
    ../../system/users.nix
    ../../modules/htpc.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mhtpc01";
  # Ethernet only — WiFi antennas disconnected with lid removed
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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
    alsa-utils   # For debugging audio (aplay, amixer)
  ];

  # Open SSH port (default firewall blocks it)
  # networking.firewall.allowedTCPPorts = [ 22 ];  # openssh module handles this

  system.stateVersion = "25.11";
}
