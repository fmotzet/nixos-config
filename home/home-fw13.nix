{ noctalia, ... }:
{
  imports = [
    ./home.nix
  ];

  home-manager.users.felix = {
    imports = [
      noctalia.homeModules.default
      ./noctalia.nix
    ];

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "eDP-1,2880x1920@60,0x0,1.5"
        ",preferred,auto,1"
      ];
    };
  };
}
