{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        color = {
          "1" = "blue";
          "2" = "blue";
        };
        padding = {
          left = 1;
        };
      };
      display = {
        separator = "  -> ";
        color = {
          keys = "blue";
          title = "light_blue";
        };
        key = {
          width = 7;
          type = "icon";
        };
        bar = {
          width = 10;
          char = {
            elapsed = "■" ;
          };
          charTotal = "-";
        };
        percent = {
          type = 2;
          color = {
            green = "light_blue";
            yellow = "light_yellow";
            red = "light_red";
          };
        };
      };
      modules = [
        {
          type = "datetime";
          key = "Date";
          format = "{11}/{4}/{1}___{14}:{18}:{20}";
        }
          "os"
        {
          type = "cpuusage";
        }
        "memory"
        "battery"
        "localip"
        {
          type = "publicip";
          timeout = 1000;
        }
      ];
    };
  };
}