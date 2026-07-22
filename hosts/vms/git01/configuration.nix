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

  # NFS mount for all Forgejo + PostgreSQL data (slower HDD-backed export — fine for git).
  # Kept as a hard boot mount (no idle-timeout/noauto) so PostgreSQL always has access.
  fileSystems."/mnt/git-data" = {
    device = "192.168.178.128:/srv/nfs/shared/git";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "soft"
    ];
  };

  # --- PostgreSQL (data on NFS) ---
  # Forgejo creates its own DB + user via peer auth over the local socket
  # (services.forgejo.database.createDatabase = true, the default), so no
  # password lives in this repo.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/mnt/git-data/postgresql";
  };

  # --- Forgejo (git server + built-in Actions) ---
  services.forgejo = {
    enable = true;
    # Repos, LFS, avatars, etc. all live on the NFS mount.
    stateDir = "/mnt/git-data/forgejo";

    database.type = "postgres"; # createDatabase = true by default (peer auth, local socket)

    # Store LFS objects on NFS too (default is under stateDir, set explicitly for clarity)
    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "git01";
        HTTP_PORT = 3000;
        # Update ROOT_URL to your reverse-proxy / real hostname when you have one.
        ROOT_URL = "http://git01:3000/";
      };
      # GitHub-Actions-compatible CI. Runner is registered below.
      actions.ENABLED = true;
      # Lock the instance down — no open sign-ups on a personal server.
      service.DISABLE_REGISTRATION = true;
      # Let Actions reach github.com / codeberg.org for deploy/mirror jobs.
      # (These are the defaults but pinned here so pipelines to external hosts work.)
      migrations.ALLOWED_DOMAINS = "*";
    };
  };

  # --- Forgejo Actions runner (Docker backend for best GH-Actions compatibility) ---
  # BOOTSTRAP: after Forgejo is up, create a runner registration token in the web UI
  # (Site Administration -> Actions -> Runners -> Create new Runner) and write it to
  # /mnt/git-data/runner-token, then `sudo systemctl restart gitea-runner-default`.
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

  # Docker is required for the runner's container jobs.
  virtualisation.docker.enable = true;

  # Ensure the NFS data directories exist (server export must allow root chown / no_root_squash).
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

  # 3000 = Forgejo web UI (22 is opened automatically by the openssh module).
  networking.firewall.allowedTCPPorts = [ 3000 ];

  system.stateVersion = "25.11";
}
