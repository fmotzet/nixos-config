{ lib, osConfig, ... }:
let
  inherit (lib.generators) mkLuaInline;
  
  # this is pretty cool, extra functions go here
  exitAction =
    if osConfig.networking.hostName == "nixos-TP-t14g6"
    then "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger stop & hl.dsp.exit()"
    else "hl.dsp.exit()";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # managed by NixOS module programs.hyprland.enable
    configType = "lua";
    settings = {
      # Monitor (set per-host in home-<host>.nix)

      env = [
        { _args = [ "XCURSOR_SIZE" "36" ]; }
        { _args = [ "XCURSOR_THEME" "rose-pine-hyprcursor" ]; }
        { _args = [ "HYPRCURSOR_THEME" "rose-pine-hyprcursor" ]; }
        { _args = [ "HYPRCURSOR_SIZE" "36" ]; }
      ];

      config = {
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
          col = {
            active_border = {
              colors = [ "rgba(ffffffaa)" "rgba(ffffff66)" ];
              angle = 45;
            };
            inactive_border = {
              colors = [ "rgba(ffffff33)" "rgba(ffffff22)" ];
              angle = 45;
            };
          };
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
        };

        cursor = {
          no_hardware_cursors = 0;
          enable_hyprcursor = true;
          persistent_warps = true;
        };

        dwindle = {
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = -1;
        };
      };

      # Bezier curves (hl.curve), referenced by name in animations below
      curve = [
        {
          _args = [
            "myBezier"
            { type = "bezier"; points = [ [ 0.05 0.9 ] [ 0.1 1.05 ] ]; }
          ];
        }
        {
          _args = [
            "smooth"
            { type = "bezier"; points = [ [ 0.25 0.1 ] [ 0.25 1 ] ]; }
          ];
        }
      ];

      animation = [
        { leaf = "windows"; enabled = true; speed = 5; bezier = "smooth"; style = "slide"; }
        { leaf = "windowsOut"; enabled = true; speed = 5; bezier = "smooth"; style = "slide"; }
        { leaf = "border"; enabled = true; speed = 10; bezier = "smooth"; }
        { leaf = "borderangle"; enabled = true; speed = 100; bezier = "smooth"; style = "loop"; }
        { leaf = "fade"; enabled = true; speed = 5; bezier = "smooth"; }
        { leaf = "workspaces"; enabled = true; speed = 5; bezier = "smooth"; style = "slidefadevert"; }
      ];

      bind = [
        { _args = [ "SUPER + Q" (mkLuaInline ''hl.dsp.exec_cmd("kitty")'') ]; }
        { _args = [ "SUPER + W" (mkLuaInline ''hl.dsp.exec_cmd("kitty yazi")'') ]; }
        { _args = [ "SUPER + C" (mkLuaInline "hl.dsp.window.close()") ]; }
        { _args = [ "SUPER + M" (mkLuaInline exitAction) ]; }
        { _args = [ "SUPER + SHIFT + F" (mkLuaInline "hl.dsp.window.fullscreen()") ]; }
        { _args = [ "SUPER + V" (mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'') ]; }
        { _args = [ "SUPER + R" (mkLuaInline ''hl.dsp.exec_cmd("yazi")'') ]; }
        { _args = [ "SUPER + P" (mkLuaInline "hl.dsp.window.pseudo()") ]; }
        { _args = [ "SUPER + J" (mkLuaInline ''hl.dsp.layout("togglesplit")'') ]; }
        { _args = [ "SUPER + S" (mkLuaInline ''hl.dsp.exec_cmd("rofi -show drun -show-icons")'') ]; }
        { _args = [ "SUPER + L" (mkLuaInline ''hl.dsp.exec_cmd("hyprlock --grace 5")'') ]; }
        # Shutdown
        { _args = [ "SUPER + SHIFT + K" (mkLuaInline ''hl.dsp.exec_cmd("shutdown now")'') ]; }
        # Screenshot
        { _args = [ "SUPER + SHIFT + S" (mkLuaInline ''hl.dsp.exec_cmd("hyprshot -m region")'') ]; }
        { _args = [ "SUPER + SHIFT + X" (mkLuaInline ''hl.dsp.exec_cmd("hyprshot -m output -m DP-4")'') ]; }
        # Apps
        { _args = [ "SUPER + SHIFT + C" (mkLuaInline ''hl.dsp.exec_cmd("code --enable-features=UseOzonePlatform --ozone-platform=wayland")'') ]; }
        # env -u DISPLAY forces Spotify (old CEF, v1.2.86.502) onto native Wayland
        # instead of XWayland, so it uses the server-side hyprcursor like other apps.
        { _args = [ "SUPER + SHIFT + B" (mkLuaInline ''hl.dsp.exec_cmd("env -u DISPLAY spotify")'') ]; }
        # Brightness and volume
        { _args = [ "XF86MonBrightnessUp" (mkLuaInline ''hl.dsp.exec_cmd("brightnessctl set 10%+")'') ]; }
        { _args = [ "XF86MonBrightnessDown" (mkLuaInline ''hl.dsp.exec_cmd("brightnessctl set 10%-")'') ]; }
        { _args = [ "XF86AudioRaiseVolume" (mkLuaInline ''hl.dsp.exec_cmd("amixer set Master 5%+ unmute")'') ]; }
        { _args = [ "XF86AudioLowerVolume" (mkLuaInline ''hl.dsp.exec_cmd("amixer set Master 5%- unmute")'') ]; }
        { _args = [ "XF86AudioMute" (mkLuaInline ''hl.dsp.exec_cmd("amixer set Master toggle")'') ]; }
        # Move focus
        { _args = [ "SUPER + left" (mkLuaInline ''hl.dsp.focus({ direction = "left" })'') ]; }
        { _args = [ "SUPER + right" (mkLuaInline ''hl.dsp.focus({ direction = "right" })'') ]; }
        { _args = [ "SUPER + up" (mkLuaInline ''hl.dsp.focus({ direction = "up" })'') ]; }
        { _args = [ "SUPER + down" (mkLuaInline ''hl.dsp.focus({ direction = "down" })'') ]; }
        # Switch workspaces
        { _args = [ "SUPER + 1" (mkLuaInline "hl.dsp.focus({ workspace = 1 })") ]; }
        { _args = [ "SUPER + 2" (mkLuaInline "hl.dsp.focus({ workspace = 2 })") ]; }
        { _args = [ "SUPER + 3" (mkLuaInline "hl.dsp.focus({ workspace = 3 })") ]; }
        { _args = [ "SUPER + 4" (mkLuaInline "hl.dsp.focus({ workspace = 4 })") ]; }
        { _args = [ "SUPER + 5" (mkLuaInline "hl.dsp.focus({ workspace = 5 })") ]; }
        { _args = [ "SUPER + 6" (mkLuaInline "hl.dsp.focus({ workspace = 6 })") ]; }
        { _args = [ "SUPER + 7" (mkLuaInline "hl.dsp.focus({ workspace = 7 })") ]; }
        { _args = [ "SUPER + 8" (mkLuaInline "hl.dsp.focus({ workspace = 8 })") ]; }
        { _args = [ "SUPER + 9" (mkLuaInline "hl.dsp.focus({ workspace = 9 })") ]; }
        { _args = [ "SUPER + 0" (mkLuaInline "hl.dsp.focus({ workspace = 10 })") ]; }
        # Move window to workspace
        { _args = [ "SUPER + SHIFT + 1" (mkLuaInline "hl.dsp.window.move({ workspace = 1 })") ]; }
        { _args = [ "SUPER + SHIFT + 2" (mkLuaInline "hl.dsp.window.move({ workspace = 2 })") ]; }
        { _args = [ "SUPER + SHIFT + 3" (mkLuaInline "hl.dsp.window.move({ workspace = 3 })") ]; }
        { _args = [ "SUPER + SHIFT + 4" (mkLuaInline "hl.dsp.window.move({ workspace = 4 })") ]; }
        { _args = [ "SUPER + SHIFT + 5" (mkLuaInline "hl.dsp.window.move({ workspace = 5 })") ]; }
        { _args = [ "SUPER + SHIFT + 6" (mkLuaInline "hl.dsp.window.move({ workspace = 6 })") ]; }
        { _args = [ "SUPER + SHIFT + 7" (mkLuaInline "hl.dsp.window.move({ workspace = 7 })") ]; }
        { _args = [ "SUPER + SHIFT + 8" (mkLuaInline "hl.dsp.window.move({ workspace = 8 })") ]; }
        { _args = [ "SUPER + SHIFT + 9" (mkLuaInline "hl.dsp.window.move({ workspace = 9 })") ]; }
        { _args = [ "SUPER + SHIFT + 0" (mkLuaInline "hl.dsp.window.move({ workspace = 10 })") ]; }
        # Special workspace (scratchpad)
        { _args = [ "SUPER + udiaeresis" (mkLuaInline ''hl.dsp.workspace.toggle_special("magic")'') ]; }
        # Scroll through workspaces
        { _args = [ "SUPER + mouse_down" (mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'') ]; }
        { _args = [ "SUPER + mouse_up" (mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'') ]; }
        # Media keys (locked: active on lockscreen) — was bindl
        { _args = [ "XF86AudioPlay" (mkLuaInline ''hl.dsp.exec_cmd("playerctl play-pause")'') { locked = true; } ]; }
        { _args = [ "XF86AudioNext" (mkLuaInline ''hl.dsp.exec_cmd("playerctl next")'') { locked = true; } ]; }
        { _args = [ "XF86AudioPrev" (mkLuaInline ''hl.dsp.exec_cmd("playerctl previous")'') { locked = true; } ]; }
        # Mouse binds — was bindm
        { _args = [ "SUPER + mouse:272" (mkLuaInline "hl.dsp.window.drag()") { mouse = true; } ]; }
        { _args = [ "SUPER + mouse:273" (mkLuaInline "hl.dsp.window.resize()") { mouse = true; } ]; }
      ];

      # Common startup apps (host-specific ones go in home-<host>.nix, also as `on`)
      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("blueman-applet")
                hl.exec_cmd("waybar")
                hl.exec_cmd("swaync")
                hl.exec_cmd("xrdb -load ~/.Xresources")
                -- hl.exec_cmd("noctalia-shell")
                hl.exec_cmd("awww-daemon")
                hl.exec_cmd("sleep 1 && hyprctl reload")
              end'')
          ];
        }
      ];

      window_rule = {
        match = { class = "^(code)$"; };
        opacity = "0.95 0.9 1.0";
      };

      layer_rule = [
        { match = { namespace = "rofi"; }; blur = true; ignore_alpha = 0; }
        { match = { namespace = "waybar"; }; blur = true; blur_popups = true; ignore_alpha = 0.2; }
        { match = { namespace = "noctalia-shell"; }; blur = true; blur_popups = true; ignore_alpha = 0; }
        { match = { namespace = "swaync-control-center"; }; blur = true; ignore_alpha = 0; }
        { match = { namespace = "swaync-notification-window"; }; blur = true; ignore_alpha = 0; }
      ];
    };
  };
}
