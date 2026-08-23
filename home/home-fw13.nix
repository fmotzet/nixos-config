{ ... }:
{
  imports = [
    ./home.nix
  ];

  home-manager.users.felix = {
    imports = [
      ./quickshell/quickshell.nix
    ];

    wayland.windowManager.hyprland.settings = {
      monitor = [
        { output = "eDP-1"; mode = "2880x1920@60"; position = "0x0"; scale = 1.5; }
        { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
      ];
    };
  };
}
