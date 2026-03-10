{ ... }:

# Hyprlock - liquid glass lock screen
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 400;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 2;
          blur_size = 7;
          noise = 0.02;
          brightness = 0.9;
        }
      ];

      # Time display
      label = [
        {
          text = ''cmd[update:1000] echo "<span font_weight='300'>$(date +'%H:%M')</span>"'';
          color = "rgba(255, 255, 255, 0.95)";
          font_size = 120;
          font_family = "Sans Light";
          position = "0, 200";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 8;
          shadow_color = "rgba(0, 0, 0, 0.3)";
        }
        # Date display
        {
          text = ''cmd[update:60000] echo "<span font_weight='400'>$(date +'%A, %d %B')</span>"'';
          color = "rgba(255, 255, 255, 0.7)";
          font_size = 22;
          font_family = "Sans";
          position = "0, 110";
          halign = "center";
          valign = "center";
          shadow_passes = 1;
          shadow_size = 4;
          shadow_color = "rgba(0, 0, 0, 0.2)";
        }
        # Greeting
        {
          text = "oi $USER!";
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 16;
          font_family = "Sans";
          position = "0, -30";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          size = "280, 55";
          position = "0, -100";
          monitor = "";
          dots_center = true;
          dots_size = 0.25;
          dots_spacing = 0.3;
          fade_on_empty = true;
          font_color = "rgba(255, 255, 255, 0.95)";
          inner_color = "rgba(255, 255, 255, 0.12)";
          outer_color = "rgba(255, 255, 255, 0.2)";
          outline_thickness = 2;
          rounding = 15;
          check_color = "rgba(255, 255, 255, 0.35)";
          fail_color = "rgba(255, 100, 100, 0.4)";
          fail_text = "<i>incorrect</i>";
          capslock_color = "rgba(255, 200, 100, 0.3)";
          placeholder_text = ''<span foreground="##ffffffb3">Password...</span>'';
          shadow_passes = 2;
          shadow_size = 8;
          shadow_color = "rgba(0, 0, 0, 0.15)";
        }
      ];
    };
  };
}
