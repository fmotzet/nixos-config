{ ... }:
let
  mkLiteral = value: { _type = "literal"; inherit value; };
in {
  programs.rofi = {
    enable = true;
    extraConfig = {
      show-icons = true;
      display-drun = "";
      display-window = "";
      drun-display-format = "{name}";
      disable-history = false;
      click-to-exit = true;
    };
    theme = {
      "*" = {
        bg-glass = mkLiteral "rgba(255, 255, 255, 0.12)";
        bg-glass-light = mkLiteral "rgba(255, 255, 255, 0.22)";
        bg-glass-selected = mkLiteral "rgba(255, 255, 255, 0.35)";
        bg-glass-hover = mkLiteral "rgba(255, 255, 255, 0.25)";
        fg-primary = mkLiteral "rgba(255, 255, 255, 1.0)";
        fg-secondary = mkLiteral "rgba(255, 255, 255, 0.7)";
        border-glass = mkLiteral "rgba(255, 255, 255, 0.3)";
        border-glow = mkLiteral "rgba(255, 255, 255, 0.2)";
        accent = mkLiteral "rgba(255, 255, 255, 0.9)";
        accent-glow = mkLiteral "rgba(255, 255, 255, 0.2)";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-primary";
      };
      "window" = {
        transparency = "real";
        background-color = mkLiteral "@bg-glass";
        border = mkLiteral "2px";
        border-color = mkLiteral "@border-glass";
        border-radius = mkLiteral "20px";
        width = mkLiteral "700px";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        padding = 0;
      };
      "mainbox" = {
        enabled = true;
        spacing = 0;
        background-color = mkLiteral "transparent";
        children = map mkLiteral [ "inputbar" "listview" ];
        padding = mkLiteral "15px";
      };
      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10px";
        padding = mkLiteral "20px";
        background-color = mkLiteral "@bg-glass-light";
        border-radius = mkLiteral "15px";
        margin = mkLiteral "0 0 15px 0";
        border = mkLiteral "1px";
        border-color = mkLiteral "@border-glow";
        text-color = mkLiteral "@fg-primary";
        children = map mkLiteral [ "prompt" "entry" ];
      };
      "prompt" = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent";
        font = "Sans Bold 12";
      };
      "entry" = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-primary";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@fg-secondary";
      };
      "listview" = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        spacing = mkLiteral "5px";
        background-color = mkLiteral "transparent";
        cursor = "default";
      };
      "element" = {
        enabled = true;
        spacing = mkLiteral "10px";
        padding = mkLiteral "12px";
        border-radius = mkLiteral "12px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-primary";
        cursor = mkLiteral "pointer";
      };
      "element normal.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-primary";
      };
      "element selected.normal" = {
        background-color = mkLiteral "@bg-glass-selected";
        text-color = mkLiteral "@fg-primary";
        border = mkLiteral "1px";
        border-color = mkLiteral "@accent";
      };
      "element alternate.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-primary";
      };
      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "32px";
        cursor = mkLiteral "inherit";
      };
      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
      "element selected" = {
        background-color = mkLiteral "@bg-glass-selected";
        border = mkLiteral "1px";
        border-color = mkLiteral "@border-glow";
      };
      "element-text selected" = {
        text-color = mkLiteral "white";
      };
    };
  };
}
