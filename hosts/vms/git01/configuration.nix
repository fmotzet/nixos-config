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

  # NFS mount for the git data + PostgreSQL.
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

    # We have to keep Forgejo's app-state (config + auto-generated secrets) on LOCAL disk.
    # The module bootstraps its secrets via a systemd service and LoadCredential that run at sysinit, before the NFS mount exists.
    # Pointing stateDir at NFS makes secret generation land nowhere and Forgejo fails.
    # Only the bulk data below goes on the NFS.
    repositoryRoot = "/mnt/git-data/repositories"; # the actual git repos
    lfs = {
      enable = true;
      contentDir = "/mnt/git-data/lfs"; # large LFS objects
    };

    database.type = "postgres";

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

  systemd.services.git-data-dirs = {
    description = "Create Forgejo/PostgreSQL data dirs on the NFS mount";
    after = [ "mnt-git\\x2ddata.mount" ];
    requires = [ "mnt-git\\x2ddata.mount" ];
    before = [ "postgresql.service" "forgejo.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      install -d -o postgres -g postgres -m 0700 /mnt/git-data/postgresql
      install -d -o forgejo  -g forgejo  -m 0750 /mnt/git-data/repositories
      install -d -o forgejo  -g forgejo  -m 0750 /mnt/git-data/lfs
    '';
  };

  # PostgreSQL and Forgejo must wait for the mount + the dir-creation above.
  systemd.services.postgresql = {
    after = [ "git-data-dirs.service" ];
    requires = [ "git-data-dirs.service" ];
  };
  systemd.services.forgejo = {
    after = [ "git-data-dirs.service" ];
    requires = [ "git-data-dirs.service" ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # 3000 = Forgejo web UI
  networking.firewall.allowedTCPPorts = [ 3000 ];

  system.stateVersion = "25.11";
}
