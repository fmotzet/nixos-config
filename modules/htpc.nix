# HTPC-specific module: KDE Plasma desktop, Kodi media center, HDMI-CEC,
# AMD GPU acceleration, and couch-friendly defaults.
{ config, lib, pkgs, ... }:

{
  # --- KDE Plasma Desktop ---
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Auto-login directly into Plasma session
  services.displayManager.autoLogin = {
    enable = true;
    user = "felix";
  };

  # --- AMD GPU (Radeon Vega 6 iGPU) ---
  # The amdgpu kernel driver is loaded automatically for Vega-series iGPUs.
  # VA-API provides hardware video decoding (important for 4K content).
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # VA-API driver for AMD (RADV handles Vulkan automatically via Mesa)
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };

  # Note on HDMI resolution: The ThinkPad L15 (20U70002GE) HDMI port is
  # HDMI 1.4b, which limits output to 4K@30Hz (3840x2160@30). For 60Hz you
  # would need a USB-C to HDMI 2.0 adapter — but the L15's USB-C may not
  # support DisplayPort Alt Mode. 4K@30Hz is fine for media playback; for
  # smoother UI, consider running at 1080p@60Hz instead.

  # --- AMD Power Management ---
  # amd_pstate provides efficient frequency scaling on Zen 2+
  boot.kernelParams = [
    "amd_pstate=active"
  ];

  # Use power-profiles-daemon for easy switching (defaults to balanced)
  services.power-profiles-daemon.enable = true;

  # --- Audio (PipeWire with HDMI output) ---
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # WirePlumber handles audio routing; HDMI audio output will appear as a
    # PipeWire sink automatically when the TV is connected.
    wireplumber.enable = true;
  };

  # --- HDMI-CEC (TV remote → Kodi/desktop navigation) ---
  # libcec allows the Samsung TV remote to send basic navigation commands
  # (arrows, select, back) via the HDMI-CEC bus. Kodi has built-in CEC
  # support through its libcec integration. The user needs to be in the
  # "video" group to access /dev/cec*.
  services.udev.extraRules = ''
    # Allow video group access to CEC devices
    SUBSYSTEM=="cec", MODE="0660", GROUP="video"
  '';

  # --- Kodi Media Center ---
  # Using kodi-wayland since we run KDE Plasma on Wayland.
  # Kodi is installed as an app (not as the session) so the full Plasma
  # desktop remains available.
  environment.systemPackages = with pkgs; [
    (kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
      # Jellycon: lightweight Jellyfin integration for Kodi
      jellycon
      # Jellyfin for Kodi: full sync client (richer but heavier than Jellycon)
      jellyfin
      # YouTube addon for Kodi
      youtube
      # Inputstream for adaptive streaming (DASH, HLS)
      inputstream-adaptive
      inputstreamhelper
    ]))

    jellyfin-media-player  # Standalone Jellyfin desktop client (alternative to Kodi)
    libcec                 # CEC utilities (cec-client for debugging)
    firefox                # Web browser for YouTube etc. from the couch
  ];

  # --- Display & Session Defaults (couch-friendly) ---
  # Disable screen blanking, screensaver, and DPMS — the TV handles its own sleep.
  # These are set via environment variables that KDE/Wayland respects.
  environment.sessionVariables = {
    # Hint to Qt apps to use Wayland
    QT_QPA_PLATFORM = "wayland";
  };

  # --- Lid Switch ---
  # The lid/screen assembly is removed, so the lid sensor state is undefined.
  # Ignore it to prevent unexpected suspend/shutdown.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # --- Prevent Sleep/Suspend ---
  # HTPC should always stay on and reachable via SSH.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # --- Autostart Kodi on login ---
  # Create an XDG autostart entry so Kodi launches when Plasma starts.
  environment.etc."xdg/autostart/kodi.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Kodi
    Exec=kodi
    X-KDE-autostart-phase=2
  '';

  # --- KDE Plasma display settings ---
  # Disable screen locking and screen saver via kscreenlockerrc.
  # Display scaling for 4K TV at couch distance is set to 150%.
  # To adjust: change the scaling factor below, or use System Settings > Display
  # on the HTPC after boot.
  #
  # Note: Declarative KDE config via environment.etc works for defaults;
  # the user can override in the running session.
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
