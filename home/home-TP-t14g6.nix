{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  imports = [
    ./home.nix
  ];

  home-manager.users.felix = {
    programs.bash.shellAliases = {
      tlstatus = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger status -m";
      tlstop = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger stop";
      tlbreak = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger break";
      fixdns = "sudo bash -c 'echo -e \"nameserver 10.20.36.1\\n$(cat /etc/resolv.conf)\" > /etc/resolv.conf'";
    };

    wayland.windowManager.hyprland.settings = {
      monitor = [
        { output = "eDP-1"; mode = "1920x1200@60"; position = "0x0"; scale = 1; }
        { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
      ];
      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("brave https://zabbix.muc.boerse-go.de/ https://outlook.office.com/ https://stock3.atlassian.net/jira/your-work https://monkeytype.com/ https://open.spotify.com/ http://bgtop.dc1.boerse-go.de/snapshots.php?autoRefresh=60&limit=500")
                hl.exec_cmd("teams-for-linux")
                hl.exec_cmd("TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger start")
              end'')
          ];
        }
      ];
    };
  };
}
