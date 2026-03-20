{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "[nix]"."editor.tabSize" = 2;
      "editor.fontSize" = 14;
      "workbench.sideBar.location" = "right";
      "git.autofetch" = true;
      "enableExtensionUpdateCheck" = true;
      "workbench.colorTheme" = "Default Dark Modern";
    };
    profiles.default.extensions = with pkgs.vscode-extensions; [
      anthropic.claude-code
    ];
  };
}
