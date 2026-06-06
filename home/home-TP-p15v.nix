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
      monitor = [
        { output = "eDP-1"; mode = "preferred"; position = "0x0"; scale = 1; }
        { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
      ];
      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("firefox -new-tab -url https://zabbix.muc.boerse-go.de/ -new-tab -url https://outlook.office.com/ -new-tab -url https://stock3.atlassian.net/jira/your-work -new-tab -url https://monkeytype.com/ -new-tab -url https://open.spotify.com/ -new-tab -url http://bgtop.dc1.boerse-go.de/snapshots.php?autoRefresh=60&limit=500")
                hl.exec_cmd("teams-for-linux")
              end'')
          ];
        }
      ];
    };
  };
}
