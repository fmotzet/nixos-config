{ config, lib, pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "felix";
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };

  boot.kernelParams = [
    "amd_pstate=active"
  ];

  services.power-profiles-daemon.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.udev.extraRules = ''
    # Allow video group access to CEC devices
    SUBSYSTEM=="cec", MODE="0660", GROUP="video"
  '';

  environment.systemPackages = with pkgs; [
    (kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
      jellycon
      jellyfin
      youtube
      inputstream-adaptive
      inputstreamhelper
    ]))

    jellyfin-media-player  # Standalone Jellyfin desktop client (alternative to Kodi)
    libcec                 # CEC utilities (cec-client for debugging)
    firefox                # Web browser for YouTube etc. from the couch
  ];

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  environment.etc."xdg/autostart/kodi.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Kodi
    Exec=kodi
    X-KDE-autostart-phase=2
  '';

  environment.etc."xdg/kdeglobals".text = ''
    [KScreen]
    ScaleFactor=1.5
    ScreenScaleFactors=HDMI-A-1=1.5;
  '';

  environment.etc."xdg/kscreenlockerrc".text = ''
    [Daemon]
    Autolock=false
    LockOnResume=false
  '';

  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  environment.etc."xdg/powermanagementprofilesrc".text = ''
    [AC][DPMSControl]
    idleTime=0
    lockBeforeTurnOff=0

    [AC][SuspendSession]
    idleTime=0
    suspendThenHibernate=false
    suspendType=0
  '';
}
