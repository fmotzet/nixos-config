{ ... }:
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "top";
        backgroundOpacity = 0.12;
        capsuleOpacity = 0.12;
      };
      general = {
        avatarImage = ./nixos-baw.png;
        enableBlurBehind = true;
        dimmerOpacity = 0.2;
      };
      ui = {
        panelBackgroundOpacity = 0.12;
        translucentWidgets = true;
      };
      notifications.backgroundOpacity = 0.12;
      osd.backgroundOpacity = 0.12;
      dock.backgroundOpacity = 0.12;
    };
    colors = {
      mPrimary = "#ffffff";
      mOnPrimary = "#ffffff";
      mSecondary = "#e6e6e6";
      mOnSecondary = "#ffffff";
      mTertiary = "#ffffff";
      mOnTertiary = "#ffffff";
      mError = "#ff5050";
      mOnError = "#ffffff";
      mSurface = "#ffffff";
      mOnSurface = "#ffffff";
      mSurfaceVariant = "#f0f0f0";
      mOnSurfaceVariant = "#b3b3b3";
      mHover = "#ffffff";
      mOnHover = "#ffffff";
      mOutline = "#ffffff";
      mShadow = "#000000";
    };
  };
}
