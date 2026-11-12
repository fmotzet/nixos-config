{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      userSettings = {
        "[nix]"."editor.tabSize" = 2;
        "editor.fontSize" = 14;
        "workbench.sideBar.location" = "right";
        "git.autofetch" = true;
        "workbench.colorTheme" = "Dark Modern";

        "extensions.autoUpdate" = false;
        "telemetry.telemetryLevel" = "off";
        "update.showReleaseNotes" = false;
        "workbench.enableExperiments" = false;
        "workbench.settings.enableNaturalLanguageSearch" = false;
        "sonarlint.pathToNodeExecutable" = "h2barca1k5pmvcyl9fwrzwrb4cn1b248-nodejs-22.22.2";
      };

      extensions = with pkgs.vscode-extensions; [
        anthropic.claude-code
      ];
    };
  };
}
