{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../system/users.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "git01";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    htop
    nfs-utils
  ];

  # NFS mount for all Forgejo + PostgreSQL data
  fileSystems."/mnt/git-data" = {
    device = "192.168.178.128:/srv/nfs/shared/git";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "soft"
    ];
  };

  # --- PostgreSQL (data on NFS) ---
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/mnt/git-data/postgresql";
  };

  services.forgejo = {
    enable = true;
    stateDir = "/mnt/git-data/forgejo";

    database.type = "postgres"; 

    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "git01";
        HTTP_PORT = 3000;
        ROOT_URL = "http://git01:3000/";
      };
      # GitHub-Actions-compatible CI. Runner is registered below gitea runner.
      actions.ENABLED = true;
      service.DISABLE_REGISTRATION = true;
      # Let Actions reach github.com / codeberg.org for deploy/mirror jobs.
      migrations.ALLOWED_DOMAINS = "*";
    };
  };

  # --- Forgejo Actions runner 
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "git01-docker";
      url = "http://localhost:3000";
      tokenFile = "/mnt/git-data/runner-token";
      labels = [
        "ubuntu-latest:docker://node:20-bookworm"
        "ubuntu-22.04:docker://node:20-bookworm"
        "docker:docker://node:20-bookworm"
      ];
    };
  };

  virtualisation.docker.enable = true;

  systemd.tmpfiles.rules = [
    "d /mnt/git-data/postgresql 0700 postgres postgres -"
    "d /mnt/git-data/forgejo 0750 forgejo forgejo -"
  ];

  # Make PostgreSQL and Forgejo wait for the NFS mount to come up.
  systemd.services.postgresql = {
    after = [ "mnt-git\\x2ddata.mount" ];
    requires = [ "mnt-git\\x2ddata.mount" ];
  };
  systemd.services.forgejo = {
    after = [ "mnt-git\\x2ddata.mount" ];
    requires = [ "mnt-git\\x2ddata.mount" ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # 3000 = Forgejo web UI
  networking.firewall.allowedTCPPorts = [ 3000 ];

  system.stateVersion = "25.11";
}
