{ ... }:
# wallpaper engine
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/wallpapers/current.png" ];
      wallpaper = [ ",~/wallpapers/current.png" ];
    };
  };
}