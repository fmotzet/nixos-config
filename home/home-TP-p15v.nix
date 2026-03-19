{ ... }:
{
  imports = [
    ./home.nix
  ];

  home-manager.users.felix = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "eDP-1,preferred,0x0,1"
        ",preferred,auto,1"
      ];
      exec-once = [
        "firefox -new-tab -url https://zabbix.muc.boerse-go.de/ -new-tab -url https://outlook.office.com/ -new-tab -url https://stock3.atlassian.net/jira/your-work -new-tab -url https://monkeytype.com/ -new-tab -url https://open.spotify.com/ -new-tab -url http://bgtop.dc1.boerse-go.de/snapshots.php?autoRefresh=60&limit=500"
        "teams-for-linux"
      ];
    };
  };
}
