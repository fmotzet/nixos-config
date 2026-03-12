{ ... }:
# wallpaper engine
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/felix/wallpapers/lights-in-the-arctic-5120x2160.jpg" ];
      wallpaper = [ ",/home/felix/wallpapers/lights-in-the-arctic-5120x2160.jpg" ];
    };
  };
}