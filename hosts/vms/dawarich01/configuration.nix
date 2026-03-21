{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../system/users.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "dawarich01";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    nfs-utils
    wireguard-tools
  ];

  # NFS mount for Dawarich data — removed idle-timeout/noauto
  # so it stays mounted (PostgreSQL needs persistent access)
  fileSystems."/mnt/dawarich-data" = {
    device = "192.168.178.128:/srv/nfs/shared/dawarich";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "soft"
    ];
  };

  # --- PostgreSQL with PostGIS ---
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/mnt/dawarich-data/postgresql";
    extensions = ps: [ ps.postgis ];
    authentication = ''
      # Allow local connections without password (unix socket)
      local all all trust
      # Allow Docker containers on the host to connect
      host all all 127.0.0.1/32 md5
      host all all 172.16.0.0/12 md5
    '';
    settings = {
      listen_addresses = lib.mkForce "*";
    };
    # Password is set via the init script on NFS (not in the repo)
    # The init script at /mnt/dawarich-data/pg-init.sql should contain:
    #   CREATE USER dawarich WITH PASSWORD 'your_password_here';
    #   CREATE DATABASE dawarich_production OWNER dawarich;
    #   \c dawarich_production
    #   CREATE EXTENSION IF NOT EXISTS postgis;
    initialScript = "/mnt/dawarich-data/pg-init.sql";
  };

  # --- Redis ---
  services.redis.servers.dawarich = {
    enable = true;
    port = 6379;
    settings = {
      dir = lib.mkForce "/mnt/dawarich-data/redis";
      save = [ "900 1" "300 10" ];
    };
  };

  # Ensure NFS data directories exist before services start
  systemd.tmpfiles.rules = [
    "d /mnt/dawarich-data/postgresql 0700 postgres postgres -"
    "d /mnt/dawarich-data/redis 0700 redis redis -"
    "d /mnt/dawarich-data/storage 0755 root root -"
    "d /mnt/dawarich-data/watched 0755 root root -"
    "d /mnt/dawarich-data/public 0755 root root -"
  ];

  # Make sure PostgreSQL and Redis wait for the NFS mount
  systemd.services.postgresql.after = [ "mnt-dawarich\\x2ddata.mount" ];
  systemd.services.postgresql.requires = [ "mnt-dawarich\\x2ddata.mount" ];
  systemd.services."redis-dawarich".after = [ "mnt-dawarich\\x2ddata.mount" ];
  systemd.services."redis-dawarich".requires = [ "mnt-dawarich\\x2ddata.mount" ];

  # --- Docker for Dawarich app containers ---
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      dawarich_app = {
        image = "freikin/dawarich:latest";
        ports = [ "3000:3000" ];
        volumes = [
          "/mnt/dawarich-data/storage:/rails/storage"
          "/mnt/dawarich-data/public:/rails/public"
          "/mnt/dawarich-data/watched:/rails/watched"
        ];
        environmentFiles = [ "/mnt/dawarich-data/dawarich.env" ];
        environment = {
          RAILS_ENV = "production";
          REDIS_URL = "redis://host.docker.internal:6379/0";
          DATABASE_HOST = "host.docker.internal";
          DATABASE_PORT = "5432";
          DATABASE_NAME = "dawarich_production";
          APPLICATION_HOSTS = "localhost,192.168.178.62,dawarich01,dawarich.motzfix.com";
          APPLICATION_PROTOCOL = "http";
          TIME_ZONE = "Europe/Berlin";
          RAILS_LOG_TO_STDOUT = "true";
          SELF_HOSTED = "true";
          STORE_GEODATA = "true";
        };
        extraOptions = [
          "--add-host=host.docker.internal:host-gateway"
          "--memory=4g"
          "--cpus=0.5"
        ];
        cmd = [
          "bin/rails" "server"
          "-p" "3000"
          "-b" "0.0.0.0"
        ];
        dependsOn = [];
      };

      dawarich_sidekiq = {
        image = "freikin/dawarich:latest";
        volumes = [
          "/mnt/dawarich-data/storage:/rails/storage"
          "/mnt/dawarich-data/public:/rails/public"
          "/mnt/dawarich-data/watched:/rails/watched"
        ];
        environmentFiles = [ "/mnt/dawarich-data/dawarich.env" ];
        environment = {
          RAILS_ENV = "production";
          REDIS_URL = "redis://host.docker.internal:6379/0";
          DATABASE_HOST = "host.docker.internal";
          DATABASE_PORT = "5432";
          DATABASE_NAME = "dawarich_production";
          APPLICATION_HOSTS = "localhost,192.168.178.62,dawarich01,dawarich.motzfix.com";
          APPLICATION_PROTOCOL = "http";
          TIME_ZONE = "Europe/Berlin";
          RAILS_LOG_TO_STDOUT = "true";
          SELF_HOSTED = "true";
          STORE_GEODATA = "true";
          BACKGROUND_PROCESSING_CONCURRENCY = "10";
        };
        extraOptions = [
          "--add-host=host.docker.internal:host-gateway"
        ];
        cmd = [
          "bundle" "exec"
          "sidekiq"
        ];
        dependsOn = [ "dawarich_app" ];
      };
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Open ports: 3000 (Dawarich UI)
  networking.firewall.allowedTCPPorts = [ 3000 ];

  # Allow Docker containers to reach PostgreSQL and Redis on the host
  networking.firewall.interfaces."docker0".allowedTCPPorts = [ 5432 6379 ];

  system.stateVersion = "25.11";
}
