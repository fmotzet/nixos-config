{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/users.nix
      ../../home/home-fw13.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Systemd boot optimization
  systemd.services.NetworkManager-wait-online.enable = false;
  #boot.kernel.sysctl = {
  #  "kernel.printk" = "3 3 3 3";
  #};
  #boot.kernelParams = [ "quiet" "loglevel=3" ];

  networking.hostName = "nixos-fw13";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true; 

  # Set your time zone.
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

  # Yazi File Manager
  programs.yazi.enable = true;

  # Enable zsh as default user shell
  programs.zsh.enable = true;  

  # Thunderbird Email client
  programs.thunderbird.enable = true;

  # Enable the Flatpack service
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Enable Mullvad VPN
  services.mullvad-vpn.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Enable sound hyprland brings sound
  services.pulseaudio.enable = false;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true; #enables the bluetooth applet

  nixpkgs.config.allowUnfree = true;

  services.fprintd.enable = true;

  programs.firefox.enable = true;

  environment.sessionVariables = {
    # Cursor
    XCURSOR_THEME = "rose-pine-hyprcursor";
    XCURSOR_SIZE = "36";
    #XCURSOR_PATH = "$HOME/.local/share/icons";
    
    #ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL=1;
    MOZ_ENABLE_WAYLAND = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    alsa-utils
    brave
    brightnessctl
    burpsuite
    fprintd
    libnotify
    nfs-utils
    nnn
    noto-fonts-color-emoji
    openvpn
    unzip
    vim
    vscode
    waybar
    wireguard-tools
    wireshark
    wget
    wttrbar
    xorg.xrdb
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
    # Electron is dumb
    # Example for VS Code
#    (symlinkJoin {
#      name = "vscode-wayland";
#      paths = [ vscode ];
#      buildInputs = [ makeWrapper ];
#      postBuild = ''
#        # Create a new wrapper script instead of modifying the existing binary
#        mkdir -p $out/bin
#        makeWrapper ${vscode}/bin/code $out/bin/code-wayland \
#          --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
#        
#        # Create a new desktop file instead of modifying the existing one
#        mkdir -p $out/share/applications
#        cp ${vscode}/share/applications/code.desktop $out/share/applications/code-wayland.desktop
#        sed -i 's|Exec=.*|Exec=code-wayland %F|' $out/share/applications/code-wayland.desktop
#        sed -i 's|Name=.*|Name=VS Code (Wayland)|' $out/share/applications/code-wayland.desktop
#      '';
#    })
  ];

  # List fonts installed in system profile.
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    source-han-sans
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  systemd.tmpfiles.rules = [
    "d /etc/wireguard/ 0755 root root -"
  ];
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

