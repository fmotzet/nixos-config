{ ... }:
# wallpaper engine
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/felix/wallpapers/current.jpg" ];
      wallpaper = [ ",/home/felix/wallpapers/current.jpg" ];
    };
  };
}