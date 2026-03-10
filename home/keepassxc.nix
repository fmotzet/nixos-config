{ ... }:
{
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser.UpdateBinaryPath = false; 
      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "dark";
        CompactMode = true;
        HidePasswords = true;
      };
    };
  };
}