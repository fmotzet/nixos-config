{ ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Hurmit Nerd Font";
      size = 11.0;
    };
    themeFile = "Catppuccin-Mocha";
    settings = {
      cursor_shape = "underline";
      scrollback_lines = 20000;
      strip_trailing_spaces = "smart";
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      tab_bar_style = "powerline";
      tab_bar_min_tabs = 1;
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      background_opacity = "0.9";
      cursor_trail = 3;
    };
  };
}
