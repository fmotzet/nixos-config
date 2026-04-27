{ ... }:
{
  imports = [
    ./home.nix
  ];

  home-manager.users.felix = {
    programs.bash.shellAliases = {
      tlstatus = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger status -m";
      tlstop = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger stop";
      tlbreak = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger break";
      fixdns = "sudo bash -c 'echo -e "nameserver 10.20.36.1\n$(cat /etc/resolv.conf)" > /etc/resolv.conf'"
    };

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "eDP-1,1920x1200@60,0x0,1"
        ",preferred,auto,1"
      ];
      exec-once = [
        "brave https://zabbix.muc.boerse-go.de/ https://outlook.office.com/ https://stock3.atlassian.net/jira/your-work https://monkeytype.com/ https://open.spotify.com/ http://bgtop.dc1.boerse-go.de/snapshots.php?autoRefresh=60&limit=500"
        "teams-for-linux"
        "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger start"
      ];
    };
  };
}
