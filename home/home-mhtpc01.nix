{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  imports = [
    ./home.nix
  ];

  home-manager.users.felix = {
    wayland.windowManager.hyprland.settings = {
      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("brave http://mwebsrv01:8096/")
              end'')
          ];
        }
      ];
    };
  };
}
