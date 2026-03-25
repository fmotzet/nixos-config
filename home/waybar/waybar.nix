{ ... }:
let
  toggle-bluetooth = builtins.toFile "toggle-bluetooth.sh" ''
    #!/usr/bin/env bash
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi
  '';
in
{
  xdg.configFile."waybar/images/nixos-baw.png".source = ./nixos-baw.png;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        modules-left = [
          "group/logo-user"
          "clock"
          "group/hardware"
        ];
        modules-center = [
          "hyprland/window"
          "hyprland/workspaces"
        ];
        modules-right = [
          "cava"
          "tray"
          "keyboard-state"
          "bluetooth"
          "battery"
          "group/backlight-and-slider"
          "group/audio"
        ];
        "backlight/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
          on-click = "brightnessctl set 100%";
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
          min-length = 6;
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
          tooltip = true;
          tooltip-format = "time to {timeTo}\ncycles: {cycles} | health: {health}";
        };
        bluetooth = {
          format = " {status}";
          format-disabled = "";
          format-connected = " {num_connections} connected";
          on-click = "bash ${toggle-bluetooth}";
          tooltip-format = "name: {controller_alias} connections: {num_connections}\naddr: {controller_address}";
          tooltip-format-connected = "name: {controller_alias} connections: {num_connections}\naddr: {controller_address}\nconnected to: {device_enumerate}";
          tooltip-format-enumerate-connected = "name: {controller_alias} connections: {num_connections}\naddr: {controller_address}\nconnected to: {device_enumerate}";
        };
        cpu = {
          interval = 1;
          format = "{avg_frequency} GHz   {usage}%";
          min-length = 15;
          max-length = 20;
          on-click = "kitty btop";
        };
        cava = {
          cava_config = "/home/felix/.config/cava/config";
          framerate = 30;
          sensitivity = 1;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          hide_on_silence = false;
          method = "pulse";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = true;
          noise_reduction = 0.77;
          input_delay = 2;
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          actions = {
            on-click-right = "mode";
          };
          on-click = "kitty cava";
        };
        clock = {
          interval = 60;
          tooltip = true;
          format = " {:%H:%M   %d/%m/%y}";
          tooltip-format = "<tt><big>{calendar}</big></tt>";
          on-click = "firefox -new-window https://calendar.google.com/calendar/u/1/r";
        };
        disk = {
          interval = 30;
          format = "{percentage_free}% remaining on {path}";
          path = "/";
          on-click = "kitty sh -c \"sudo du -h --max-depth=1 / | less\"";
        };
        "hyprland/workspaces" = {
          format = "{}";
          all-outputs = false;
          show-special = true;
        };
        "hyprland/window" = {
          format = "{}";
        };
        image = {
          path = "/home/felix/.config/waybar/images/nixos-baw.png";
          on-click = "kitty";
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        memory = {
          interval = 1;
          format = "{used} GiB ";
          min-length = 11;
          max-length = 15;
          on-click = "kitty btop";
          tooltip-format = "using {percentage}% of {total}GiB memory\nusing {swapPercentage}% of {swapTotal}GiB swap";
        };
        network = {
          interval = 30;
          tooltip-format = "ip: {ipaddr}\nssid: {essid}\nsig strength: {signalStrength}\nfreq: {frequency}\nup: {bandwidthUpBytes}\ndown: {bandwidthDownBytes}";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "  Muted";
          on-click = "amixer set Master toggle";
          on-scroll-up = "amixer set Master 1%+";
          on-scroll-down = "amixer set Master 1%-";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        };
        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = " Muted";
          on-click = "amixer set Capture toggle";
          on-scroll-up = "amixer set Capture 1%+";
          on-scroll-down = "amixer set Capture 1%-";
          scroll-step = 5;
        };
        temperature = {
          interval = 1;
          hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon/";
          input-filename = "temp1_input";
          format = "{temperatureC}°C ";
          min-length = 6;
          max-length = 8;
          on-click = "kitty btop";
          tooltip-format = "{temperatureC}°C\n{temperatureF}°F\n{temperatureK}°K";
        };
        tray = {
          icon-size = 13;
          spacing = 10;
        };
        user = {
          interval = 1;
          format = "{user}; uptime: {work_H}:{work_M}:{work_S}";
        };
        "group/audio" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio"
            "pulseaudio#microphone"
          ];
        };
        "group/backlight-and-slider" = {
          orientation = "horizontal";
          modules = [
            "backlight"
            "backlight/slider"
          ];
          drawer = {
            transition-duration = 500;
          };
        };
        "group/hardware" = {
          orientation = "horizontal";
          modules = [
            "group/hardware-always-visible"
            "cpu"
            "network"
            "disk"
          ];
          drawer = {
            transition-duration = 500;
          };
        };
        "group/hardware-always-visible" = {
          orientation = "horizontal";
          modules = [
            "temperature"
            "memory"
          ];
        };
        "group/logo-user" = {
          orientation = "horizontal";
          modules = [
            "image"
            "user"
          ];
          drawer = {
            transition-duration = 500;
          };
        };
      };
    };
    style = ''
      * {
          border: none;
          border-radius: 12px;
          font-family: "Monofur Nerd Font", "Regular";
          font-size: 15px;
          min-height: 0;
      }

      window#waybar {
          background: rgba(219, 219, 220, 0.0);
          color: #ffffff;
          border-bottom: 1px solid rgba(255, 255, 255, 0);
      }

      tooltip {
          background: rgba(20, 20, 35, 0.95);
          border-radius: 12px;
          border-width: 1px;
          border-style: solid;
          border-color: rgba(255, 255, 255, 0.2);
          color: #ffffff;
      }

      #backlight {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #backlight:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #backlight-slider  {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          border: 1px solid rgba(255, 255, 255, 0.2);
      }
      #backlight-slider slider {
          min-height: 0px;
          min-width: 0px;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
      }
      #backlight-slider trough {
          min-height: 6px;
          min-width: 60px;
          border-radius: 10px;
          background: rgba(0, 0, 0, 0.3);
          border: 1px solid rgba(255, 255, 255, 0.1);
      }
      #backlight-slider highlight {
          min-width: 6px;
          border-radius: 10px;
          background: rgba(255, 255, 255, 0.8);
          border: none;
      }
      #battery {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #battery:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #bluetooth {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #bluetooth:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #cpu {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #cpu:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #cava {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: rgb(255, 255, 255);
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #cava:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #clock {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #clock:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #disk {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #disk:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #workspaces {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 8px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
      }
      #workspaces button {
          background: rgba(255, 255, 255, 0.05);
          border-radius: 10px;
          margin: 2px 4px;
          padding: 2px 8px;
          border: 1px solid rgba(255, 255, 255, 0.1);
          transition: all 0.3s ease;
      }
      #workspaces button label {
          color: rgba(255, 255, 255, 0.7);
      }
      #workspaces button.active {
          background: rgba(255, 255, 255, 0.25);
          border-color: rgba(255, 255, 255, 0.4);
      }
      #workspaces button.active label {
          color: #ffffff;
      }
      #workspaces button:hover {
          background: rgba(255, 255, 255, 0.15);
          border-color: rgba(255, 255, 255, 0.25);
          box-shadow: inherit;
          text-shadow: inherit;
      }
      #window {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #window:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #image {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #image:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #keyboard-state {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #keyboard-state:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #memory {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #memory:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #network {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #network:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #pulseaudio {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #pulseaudio:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #pulseaudio.microphone {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #pulseaudio.microphone:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #temperature {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #temperature:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #tray {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #tray:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
      #user {
          background: rgba(255, 255, 255, 0.12);
          border-radius: 12px;
          padding: 4px 12px;
          margin-left: 3px;
          margin-right: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.2);
          transition: all 0.3s ease;
      }
      #user:hover {
          background: rgba(255, 255, 255, 0.18);
          border-color: rgba(255, 255, 255, 0.3);
      }
    '';
  };
}
