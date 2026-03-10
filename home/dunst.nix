{ ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";

        # Geometry
        width = "(200, 400)";
        height = "(0, 300)";
        origin = "top-right";
        offset = "12x12";
        scale = 0;
        notification_limit = 20;

        # Appearance - liquid glass
        transparency = 0;
        corner_radius = 12;
        corners = "all";
        frame_width = 1;
        frame_color = "rgba(255, 255, 255, 0.2)";
        separator_color = "frame";
        separator_height = 1;
        gap_size = 6;

        # Progress bar
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 150;
        progress_bar_max_width = 400;
        progress_bar_corner_radius = 6;
        progress_bar_corners = "all";

        # Icons
        icon_corner_radius = 8;
        icon_corners = "all";
        enable_recursive_icon_lookup = true;
        icon_theme = "Adwaita";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;

        # Text
        font = "Monofur Nerd Font 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        indicate_hidden = true;

        # Padding
        padding = 12;
        horizontal_padding = 14;
        text_icon_padding = 10;

        # Interaction
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
        sticky_history = true;
        history_length = 20;

        # Wayland
        force_xwayland = false;
      };

      urgency_low = {
        background = "#dbdbffc7";
        foreground = "#FFFFFFB3";
        frame_color = "#FFFFFF33";
        timeout = 5;
      };

      urgency_normal = {
        background = "#dbdbffc7";
        foreground = "#FFFFFFFF";
        frame_color = "#FFFFFF33";
        timeout = 8;
      };

      urgency_critical = {
        background = "#dbdbffc7";
        foreground = "#FFFFFFFF";
        frame_color = "#FF4444AA";
        timeout = 0;
        override_pause_level = 60;
      };
    };
  };
}
