{ config, lib, pkgs, ... }:

let
  runnerConfig = pkgs.writeText "forgejo-runner-config.yaml" (builtins.toJSON {
    log.level = "info";
    runner = {
      capacity = 1;
      labels = [
        "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
        "ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
        "node:docker://node:20-bookworm"
      ];
    };
    server.connections.forgejo = {
      url = "http://localhost:3000/";
      uuid = "ffc5038f-563f-457f-adf4-a6bc68b7ff0e";
      token_url = "file://$CREDENTIALS_DIRECTORY/token";
    };
  });
in
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
    config.services.forgejo.package
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

  # --- Forgejo Actions runner (connection mode) ---
  # Newer Forgejo dropped the shared "registration token" flow that
  # services.gitea-actions-runner uses (forgejo-runner register --token), which
  # now returns 400 / "registration token not found". Instead the runner is
  # pre-created in the UI (Site Admin -> Actions -> Runners -> Create new Runner),
  # yielding a uuid + token; the daemon just connects with those (see runnerConfig).
  systemd.services.forgejo-runner = {
    description = "Forgejo Actions Runner (connection mode)";
    after = [ "network-online.target" "forgejo.service" "docker.service" "mnt-git\\x2ddata.mount" ];
    wants = [ "network-online.target" ];
    requires = [ "docker.service" "mnt-git\\x2ddata.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.forgejo-runner}/bin/forgejo-runner daemon --config ${runnerConfig}";
      # Raw 40-char token file on NFS, exposed to the daemon as a systemd credential.
      LoadCredential = [ "token:/mnt/git-data/runner-token" ];
      DynamicUser = true;
      StateDirectory = "forgejo-runner";
      WorkingDirectory = "%S/forgejo-runner";
      SupplementaryGroups = [ "docker" ];
      Restart = "on-failure";
      RestartSec = "5s";
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
