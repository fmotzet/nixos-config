{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/users.nix
      ../../home/home-TP-t14g6.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Systemd boot opotimization
  # systemd.services.NetworkManager-wait-online.enable = false;
  #boot.kernel.sysctl = {
  #  "kernel.printk" = "3 3 3 3";
  #};
  #boot.kernelParams = [ "quiet" "loglevel=3" ];

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

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true; #enables the bluetooth applet


  nixpkgs.config.allowUnfree = true;

  services.fprintd.enable = true;

  programs.firefox.enable = true;
  programs.wireshark.enable = true;
  programs.obs-studio.enable = true;

  environment.sessionVariables = {
    # Cursor
    XCURSOR_THEME = "rose-pine-hyprcursor";
    XCURSOR_SIZE = "36";
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
    brave
    brightnessctl
    dnsmasq
    fprintd
    libnotify
    networkmanager_strongswan
    nfs-utils
    noto-fonts-color-emoji
    openvpn
    strongswan
    teams-for-linux
    unzip
    vscodium
    vim
    wireguard-tools
    wget
    wttrbar
    xorg.xrdb
    yazi
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
    # Electron is dumb
    # Example for VS Code
    (symlinkJoin {
      name = "vscode-wayland";
      paths = [ vscode ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        # Create a new wrapper script instead of modifying the existing binary
        mkdir -p $out/bin
        makeWrapper ${vscode}/bin/code $out/bin/code-wayland \
          --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
        
        # Create a new desktop file instead of modifying the existing one
        mkdir -p $out/share/applications
        cp ${vscode}/share/applications/code.desktop $out/share/applications/code-wayland.desktop
        sed -i 's|Exec=.*|Exec=code-wayland %F|' $out/share/applications/code-wayland.desktop
        sed -i 's|Name=.*|Name=VS Code (Wayland)|' $out/share/applications/code-wayland.desktop
      '';
    })
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

