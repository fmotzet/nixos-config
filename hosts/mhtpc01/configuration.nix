# mhtpc01 — HTPC (ThinkPad L15, AMD Ryzen 5 4500U)
# Mounted behind a 65" Samsung 4K TV, lid removed, HDMI output only.
# Input: Logitech K400 Plus via USB Unifying receiver.
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
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
  # User config: add video group for CEC device access
  users.users.felix.extraGroups = [ "video" ];

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # try to enable HDMI audio output by default, and lower priority for analog output.
  environment.etc."wireplumber/wireplumber.conf.d/50-hdmi-default.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [ { node.name = "~alsa_output.*hdmi.*" } ]
        actions.update-props = { priority.session = 2000 }
      }
      {
        matches = [ { node.name = "~alsa_output.*analog.*" } ]
        actions.update-props = { priority.session = 100 }
      }
    ]
  '';

  # Hyprland (Wayland session for the HTPC)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Autologin straight into Hyprland on boot
  # initial_session runs once at startup; default_session relaunches the session (still passwordless) if Hyprland ever exits.
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "felix";
      };
      default_session = {
        command = "start-hyprland";
        user = "felix";
      };
    };
  };

  # SSH for remote administration
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    btop
    htop
    spotify
    vim
    wget
  ];

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  system.stateVersion = "25.11";
}
