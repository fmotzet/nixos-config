{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # managed by NixOS module programs.hyprland.enable
    settings = {
      # Monitor (set per-host in home-<host>.nix)
 
      env = [
        "XCURSOR_SIZE,36"
        "XCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,36"
      ];

      input = {
        kb_layout = "de";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };

      general = {
        gaps_in = 3;
        gaps_out = 6;
        border_size = 1;
        "col.active_border" = "rgba(ffffffaa) rgba(ffffff66) 45deg";
        "col.inactive_border" = "rgba(ffffff33) rgba(ffffff22) 45deg";
        layout = "dwindle";
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 1;
          passes = 2;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "smooth, 0.25, 0.1, 0.25, 1"
        ];
        animation = [
          "windows, 1, 5, smooth, slide"
          "windowsOut, 1, 5, smooth, slide"
          "border, 1, 10, smooth"
          "borderangle, 1, 100, smooth, loop"
          "fade, 1, 5, smooth"
          "workspaces, 1, 5, smooth, slidefadevert"
        ];
      };

      cursor = {
        no_hardware_cursors = 0;
        enable_hyprcursor = true;
        persistent_warps = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = -1;
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, W, exec, kitty yazi"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod SHIFT, F, fullscreen"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, yazi"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, S, exec, noctalia-shell ipc call launcher toggle"
        # Lock screen
        "$mainMod, L, exec, noctalia-shell ipc call lockScreen lock"
        # Shutdown
        "$mainMod SHIFT, k, exec, shutdown now"
        # Screenshot
        "$mainMod SHIFT, s, exec, hyprshot -m region"
        "$mainMod SHIFT, x, exec, hyprshot -m output -m DP-4"
        # Apps
        "$mainMod SHIFT, c, exec, code --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "$mainMod SHIFT, b, exec, spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
        # Brightness and volume
        ", xf86monbrightnessup, exec, brightnessctl set 10%+"
        ", xf86monbrightnessdown, exec, brightnessctl set 10%-"
        ", xf86audioraisevolume, exec, amixer set Master 5%+ unmute"
        ", xf86audiolowervolume, exec, amixer set Master 5%- unmute"
        ", xf86audiomute, exec, amixer set Master toggle"
        # Move focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        # Switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        # Move window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        # Special workspace (scratchpad)
        "$mainMod, ü, togglespecialworkspace, magic"
        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Media key binds
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Mouse binds
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Common startup apps (host-specific ones go in home-<host>.nix)
      exec-once = [
        "nm-applet --indicator"
        "blueman-applet"
        "xrdb -load ~/.Xresources"
        "noctalia-shell"
        "sleep 1 && hyprctl reload"
      ];

      windowrulev2 = [
        "opacity 0.95 0.9, class:^(code)$"
      ];

      layerrule = [
        "blur, rofi"
        "ignorezero, rofi"
        "blur, waybar"
        "ignorezero, waybar"
        "blurpopups, waybar"
        "ignorealpha 0.2, waybar"
        "blur, swaync-control-center"
        "ignorezero, swaync-control-center"
        "blur, swaync-notification-window"
        "ignorezero, swaync-notification-window"
      ];
    };
  };
}
