{ config, lib, pkgs, pkgs-unstable, nixpkgs-unstable, ... }:

{
  # Immich module + package from unstable; postgres/redis stay on stable.
  disabledModules = [ "services/web-apps/immich.nix" ];

  imports = [
    ./hardware-configuration.nix
    ../../../system/users.nix
    ../shared.nix
    "${nixpkgs-unstable}/nixos/modules/services/web-apps/immich.nix"
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "immich01";
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
    wireguard-tools
  ];

  # NFS mount for the photo library.
  fileSystems."/mnt/immich-data" = {
    device = "192.168.178.128:/srv/nfs/shared/immich";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "hard"
    ];
  };

  #Immich writes nightly DB dumps into <mediaLocation>/backups,(NFS).
  services.postgresql.package = pkgs.postgresql_17;

  # btrfs root: compress the nix store, but no CoW for the DB.
  # +C only applies to files created afterwards, so it has to exist before initdb.
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  systemd.tmpfiles.rules = [
    "d /var/lib/postgresql 0750 postgres postgres -"
    "h /var/lib/postgresql - - - - +C"
  ];

  services.immich = {
    enable = true;
    package = pkgs-unstable.immich;
    host = "0.0.0.0";
    port = 2283;
    openFirewall = true;
    mediaLocation = "/mnt/immich-data/library";
  };

  # Fixed ids: the NFS (v3) only sees the numeric uid, so a reinstalled VM has to get the same one or it loses access to the library.
  users.users.immich.uid = 970;
  users.groups.immich.gid = 970;

  # Immich must not start (and write into the empty mountpoint) without the NFS.
  systemd.services.immich-server.unitConfig.RequiresMountsFor = [ "/mnt/immich-data" ];

  # tmpfiles runs before the NFS is mounted, so create the media dir here instead.
  systemd.services.immich-data-dirs = {
    description = "Create the Immich media dir on the NFS mount";
    unitConfig.RequiresMountsFor = [ "/mnt/immich-data" ];
    before = [ "immich-server.service" ];
    requiredBy = [ "immich-server.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      install -d -o immich -g immich -m 0700 /mnt/immich-data/library
    '';
  };

  networking.wg-quick.interfaces.wg0.configFile = "/etc/wireguard/wg0.conf";

  systemd.services.wg-quick-wg0.serviceConfig = {
    Restart = "on-failure";
    RestartSec = 10;
  };
  systemd.services.wg0-watchdog = {
    description = "Restart wg0 if the tunnel is down or stale";
    after = [ "wg-quick-wg0.service" ];
    path = [ pkgs.wireguard-tools ];
    serviceConfig.Type = "oneshot";
    script = ''
      if ! wg show wg0 > /dev/null 2>&1; then
        echo "wg0 interface missing, restarting wg-quick-wg0"
        systemctl restart wg-quick-wg0.service
        exit 0
      fi

      now=$(date +%s)
      newest=0
      for hs in $(wg show wg0 latest-handshakes | cut -f2); do
        if [ "$hs" -gt "$newest" ]; then newest=$hs; fi
      done

      if [ "$newest" -eq 0 ] || [ $((now - newest)) -gt 300 ]; then
        echo "wg0 handshake stale (last: $newest), restarting wg-quick-wg0"
        systemctl restart wg-quick-wg0.service
      fi
    '';
  };

  systemd.timers.wg0-watchdog = {
    description = "Periodic wg0 tunnel health check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1min";
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  system.stateVersion = "26.05";
}
