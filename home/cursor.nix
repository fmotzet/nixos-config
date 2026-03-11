{ pkgs, ... }:
{
  home.pointerCursor = {
    name = "rose-pine-hyprcursor";
    package = pkgs.rose-pine-hyprcursor;
    size = 36;
    hyprcursor.enable = true;
    gtk.enable = true;
  };
}
