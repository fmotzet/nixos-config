{ noctalia, ... }:
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
      ./swaync.nix
      ./hyprlock.nix
      ./fastfetch.nix
      ./kitty.nix
      ./claude-code.nix
      ./waybar/waybar.nix
      ./hyprland.nix
      ./cursor.nix
      ./keepassxc.nix
      ./direnv.nix
      ./vscode.nix
      noctalia.homeModules.default
      ./noctalia/noctalia.nix
      ./yazi.nix
    ] ++ (if builtins.pathExists ./git-personal.nix then [ ./git-personal.nix ] else []);
    
    programs.bash = {
      enable = true;
      historySize = 100000;
      historyFileSize = 200000;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/felix/nixos-config/";
        nix-dev-init = "cp /home/felix/nixos-config/templates/rust/flake.nix . && echo 'use flake' > .envrc && git add flake.nix .envrc && direnv allow";
        shsh = "start-hyprland";
        # is this cool?
        tpwgen = "nix-shell -p pwgen --run 'pwgen 16'";
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
      settings.user.name = "fmotzet";
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
    services.awww = {
      enable = true;
    };
  };
}

