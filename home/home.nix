{config, pkgs, ... }:
{
  # If we have legacy, non generated files, rename them to bak instead of failing
  home-manager.backupFileExtension = "bak";

  # Users who's home we want to configure
  home-manager.users.felix = {
    home.stateVersion = "23.05";
    # force wayland for qt Apps like keepassxc
    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
    };
    
    nixpkgs.config.allowUnfree = true;    

    imports = [
      ./rofi.nix
      ./dunst.nix 
      ./hyprlock.nix
      ./fastfetch.nix
      ./kitty.nix
      ./keepassxc.nix
    ];
    
    programs.git = {
      enable = true;
    };
    # Cava audio visualizer
    programs.cava = {
      enable = true;
      settings = {
        general.live-config = 1;
        general.framerate = 60;
        general.autosens = 1;
        general.bar_width = 1;
        general.sleep_timer = 10;
        output.orientation = "top";
        smoothing.noise_reduction = 88;
        color = {
            foreground = "'#FFFFFF'";
        };
      };
    };
    # btop process and system monitor
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
        graph_symbol = "braille";
        update_ms = 2000;
        proc_sorting = "memory";
        proc_tree = "true";
      };
    };
    # discord chat client
    programs.discord = {
      enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
      };
    };
    # hyprshot screenshot tool
    programs.hyprshot = {
      enable = true;
      saveLocation = "~/screenshots/";
    };
    # mullvad vpn client
    programs.mullvad-vpn = {
      enable = true;
    };
    programs.network-manager-applet = {
      enable = true;
    };
  };
}

