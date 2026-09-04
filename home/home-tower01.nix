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
        { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
      ];
    };
  };
}
