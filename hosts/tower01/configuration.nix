{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/users.nix
      ../../home/home-tower01.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Systemd boot optimization
  systemd.services.NetworkManager-wait-online.enable = false;
  #boot.kernel.sysctl = {
  #  "kernel.printk" = "3 3 3 3";
  #};
  #boot.kernelParams = [ "quiet" "loglevel=3" ];

  networking.hostName = "tower01";
  networking.networkmanager.enable = true; 
  networking.firewall.allowedUDPPorts = [ 16261 16262 ]; # project zomboid

  time.timeZone = "Europe/Berlin";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable power profile deamon
  services.power-profiles-daemon.enable = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # Enable hyprlock for PAM authentication
  programs.hyprlock.enable = true;

  # Enable zsh as default user shell
  programs.zsh.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;
  users.users.felix.extraGroups = [ "docker" ];

  # Thunderbird Email client
  programs.thunderbird.enable = true;

  # Enable the Flatpack service
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Enable Mullvad VPN
  services.mullvad-vpn.enable = true;

  # Enable Upower for enumerating power devices
  services.upower.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Enable sound hyprland brings sound
  services.pulseaudio.enable = false;

  programs.firefox.enable = true;
  
  # nix-ld to load and test binaries, pretty cool
  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL=1;
    MOZ_ENABLE_WAYLAND = "1";
  };

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    alsa-utils
    brightnessctl
    burpsuite
    fprintd
    gdb
    libnotify
    nfs-utils
    nnn
    noto-fonts-color-emoji
    openvpn
    pkgs-unstable.ratty
    unzip
    spotify
    vim
    wireguard-tools
    wireshark
    wget
    wttrbar
    xrdb
    zsh
    # Python
    (python3.withPackages(ps: with ps; [
      argparse
      beautifulsoup4
      jsonschema
      openai
      pandas
      playwright
      pycryptodome
      requests
      thttp
      wikipedia
    ]))
  ];

  # List fonts installed in system profile.
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    source-han-sans
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  systemd.tmpfiles.rules = [
    "d /etc/wireguard/ 0755 root root -"
  ];

  system.stateVersion = "26.05"; # Did you read the comment?

}

