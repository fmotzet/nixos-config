{config, pkgs, ... }:
{
  # If we have legacy, non generated files, rename them to bak instead of failing
  home-manager.backupFileExtension = "bak";

  # Users who's home we want to configure
  home-manager.users.felix = {
    home.stateVersion = "23.05";
    
    nixpkgs.config.allowUnfree = true;    

    imports = [
      # Rofi app launcher 
      ./rofi.nix
      ./dunst.nix 
      ./hyprlock.nix
    ];
    
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
            # background = "'#000000'";
            foreground = "'#FFFFFF'";
        };
      };
    };
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
    programs.discord = {
      enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
      };
    };
    programs.fastfetch= {
      enable = true;
      settings = {
        logo = {
          type = "small";
          color = {
            "1" = "blue";
            "2" = "blue";
          };
          padding = {
            left = 1;
          };
        };
        display = {
          separator = "  -> ";
          color = {
            keys = "blue";
            title = "light_blue";
          };
          key = {
            width = 7;
            type = "icon";
          };
          bar = {
            width = 10;
            char = {
              elapsed = "■" ;
            };
            charTotal = "-";
          };
          percent = {
            type = 2;
            color = {
              green = "light_blue";
              yellow = "light_yellow";
              red = "light_red";
            };
          };
        };
        modules = [
          {
            type = "datetime";
            key = "Date";
            format = "{11}/{4}/{1}___{14}:{18}:{20}";
          }
            "os"
          {
            type = "cpuusage";
          }
          "memory"
          "battery"
          "localip"
          {
            type = "publicip";
            timeout = 1000;
          }
        ];
      };
    };      
  };
}

