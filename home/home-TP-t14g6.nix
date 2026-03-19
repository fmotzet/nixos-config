{ ... }:
{
  imports = [
    ./home.nix
    ./keepassxc.nix
  ];

  home-manager.users.felix = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "eDP-1,1920x1200@60,0x0,1"
        ",preferred,auto,1"
      ];
      exec-once = [
        "brave https://zabbix.muc.boerse-go.de/ https://outlook.office.com/ https://stock3.atlassian.net/jira/your-work https://monkeytype.com/ https://open.spotify.com/ http://bgtop.dc1.boerse-go.de/snapshots.php?autoRefresh=60&limit=500"
        "teams-for-linux"
      ];
    };
  };
}
