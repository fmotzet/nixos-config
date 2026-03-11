{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # managed by NixOS module programs.hyprland.enable
    settings = {
      # Monitor
      monitor = "eDP-1,1920x1080@144,0x0,1";

      # Environment variables
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,36"
      ];

      # Input
      input = {
        kb_layout = "de";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };

      # General
      general = {
        gaps_in = 2;
        gaps_out = 3;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(faa0e2ee) rgba(ffffffee) 45deg";
        layout = "dwindle";
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 2;
        active_opacity = 0.99;
        inactive_opacity = 0.93;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Misc
      misc = {
        force_default_wallpaper = -1;
      };

      # Variables
      "$mainMod" = "SUPER";

      # Keybinds
      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, W, exec, kitty yazi"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, exec, togglegroup,"
        "$mainMod, S, exec, rofi -show drun -show-icons"
        # Lock screen
        "$mainMod, L, exec, hyprlock --grace 5"
        # Shutdown
        "$mainMod SHIFT, k, exec, shutdown now"
        # Change split direction
        "$mainMod SHIFT, p, togglesplit"
        # Screenshot
        "$mainMod SHIFT, s, exec, hyprshot -m region"
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

      # Locked binds (work even when locked)
      bindl = [
        ", xf86monbrightnessup, exec, brightnessctl set 10%+"
        ", xf86monbrightnessdown, exec, brightnessctl set 10%-"
        ", xf86audioraisevolume, exec, amixer set Master 5%+ unmute"
        ", xf86audiolowervolume, exec, amixer set Master 5%- unmute"
        ", xf86audiomute, exec, amixer set Master toggle"
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
        "waybar"
        "dunst"
        "xrdb -load ~/.Xresources"
        "kitty --detach btop"
        "sleep 1 && hyprctl reload"
      ];

      # Layer rules
      layerrule = [
        "blur, rofi"
        "ignorezero, rofi"
        "blur, waybar"
        "ignorezero, waybar"
      ];
    };
  };
}
