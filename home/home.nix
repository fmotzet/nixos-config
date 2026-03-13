{ ... }:
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

    xdg.portal.config.common.default = "*";

    imports = [
      ./rofi.nix
      ./dunst.nix
      ./hyprlock.nix
      ./fastfetch.nix
      ./kitty.nix
      ./claude-code.nix
      ./hyprpaper.nix
      ./waybar.nix
      ./hyprland.nix
      ./cursor.nix
    ];
    
    programs.bash = {
      enable = true;
      historySize = 100000;
      historyFileSize = 200000;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/felix/nixos-config/";
      };
      initExtra = ''
        if [ "$TERM" = "xterm-kitty" ]; then
          fastfetch
          PS1="\n\[\033[01;34m\]<\w> $\[\033[00m\] "
        fi
      '';
    };

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
    # gui app for network manager
    services.network-manager-applet = {
      enable = true;
    };
    # playerctl media controller
    services.playerctld = {
      enable = true;
    };
    # ripgrep search tool
    programs.ripgrep = {
      enable = true;
    };
    # spotify media player
    programs.spotify-player = {
      enable = true;
    };
    # brave browser with dark mode
    programs.brave = {
      enable = true;
      commandLineArgs = [
        "--force-dark-mode"
        "--enable-features=WebUIDarkMode"
      ];
    };
    services.swww = {
      enable = true;
    };
  };
}

