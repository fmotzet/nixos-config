{ config, lib, pkgs, pkgs-unstable, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/users.nix
      ../../system/rdm.nix
      ../../home/home-TP-t14g6.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  
  # Systemd boot opotimization
  # systemd.services.NetworkManager-wait-online.enable = false;
  #boot.kernel.sysctl = {
  #  "kernel.printk" = "3 3 3 3";
  #};
  #boot.kernelParams = [ "quiet" "loglevel=3" ];
  boot.blacklistedKernelModules = [ "algif_aead" ];

  networking.hostName = "nixos-TP-t14g6";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

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
  users.users.felix.extraGroups = [ "docker" "wireshark" ];

  # Enable howdy face recognition
  # services.howdy = {
  #   enable = true;
  #   settings = {
  #     video = {
  #       device_path = "/dev/video2";
  #       dark_threshold = 60;
  #       certainty = 3.5;
  #     };
  #   };
  # };
 
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    browsing = true;
    browsed.enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;  # mDNS resolution
    openFirewall = true;
  };
  services.samba = {
    enable = true;
    settings.global = {
      workgroup = "AD";
      realm = "ad.boerse-go.de";
    };
  };  
  # Enable sound. Hyprland enables pipewire-plus so we disable pulseaudio
  services.pulseaudio.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the Flatpack service
  services.flatpak.enable = true;

  # Enable the Mullvad background service
  services.mullvad-vpn.enable = true;

  # Enable fwupdate service for firmware updates
  services.fwupd.enable = true;

  # Power & thermal management
  services.power-profiles-daemon.enable = true;

  # Enable Upower for enumerating power devices
  services.upower.enable = true;

  # AMD pstate EPP + GPU + boost: performance mode
  systemd.tmpfiles.rules = [
    "w /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference - - - - performance"
    "w /sys/devices/system/cpu/cpufreq/boost - - - - 1"
    "w /sys/class/drm/card1/device/power_dpm_force_performance_level - - - - auto"
  ];

  # Enable thinkpad_acpi fan monitoring
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true; #enables the bluetooth applet


  nixpkgs.config.allowUnfree = true;

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     howdy = pkgs-unstable.howdy;
  #     linux-enable-ir-emitter = pkgs-unstable.linux-enable-ir-emitter;
  #   })
  # ];

  services.fprintd.enable = true;

  programs.firefox.enable = true;
  programs.wireshark.enable = true;
  programs.obs-studio.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL=1;
    MOMOZ_ENABLE_WAYLAND = "1";
  };
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "yazi.desktop" ];
    };
  };

  environment.systemPackages = with pkgs; [
    acpi
    alsa-utils
    brightnessctl
    dnsmasq
    fprintd
    libnotify
    networkmanager_strongswan
    nfs-utils
    noto-fonts-color-emoji
    openvpn
    pkgs-unstable.ratty
    spotify
    strongswan
    teams-for-linux
    unzip
    vscodium
    vim
    wireguard-tools
    wget
    wttrbar
    xorg.xrdb
    zsh
    # haskell
    ghc
    cabal-install
    haskell-language-server
    haskellPackages.hlint
    # Python
    (python3.withPackages(ps: with ps; [ 
      ansible
      beautifulsoup4
      flask
      html2text
      jsonschema
      lxml
      magic
      openai
      pandas
      psycopg2
      python-dotenv
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
    source-han-serif
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  system.stateVersion = "25.11"; # Did you read the comment?

}

