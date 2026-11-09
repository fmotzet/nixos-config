{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../system/users.nix
    ../shared.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "mnextcloud01";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    nfs-utils
    htop
  ];

  # NFS mount for Nextcloud data
  fileSystems."/mnt/nextcloud-data" = {
    device = "192.168.178.128:/srv/nfs/shared/nextcloud";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "soft"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "noauto"
    ];
  };

  # Nextcloud
  # Before first activation, create the admin password file:
  #   echo -n "your-password" > /etc/nextcloud-admin-pass
  #   chmod 400 /etc/nextcloud-admin-pass
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    hostName = "mnextcloud01";
    datadir = "/mnt/nextcloud-data";
    https = false;
    configureRedis = true;
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    settings = {
      overwriteprotocol = "http";
      default_phone_region = "DE";
      trusted_domains = [
        "mnextcloud01"
        "192.168.178.131"
      ];
    };
  };

  # Open HTTP port
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  system.stateVersion = "25.11";
}
