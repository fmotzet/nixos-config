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
    # Frosted glass palette
    # "m*" = background/accent colors, "mOn*" = foreground/text on top
    # Surfaces are white (opacity settings make them translucent)
    # Accents use light gray so indicators/bars don't disappear
    colors = {
      mPrimary = "#b3b3b3";
      mOnPrimary = "#ffffff";
      mSecondary = "#a0a0a0";
      mOnSecondary = "#ffffff";
      mTertiary = "#c8c8c8";
      mOnTertiary = "#ffffff";
      mError = "#ff5050";
      mOnError = "#ffffff";
      mSurface = "#ffffff";
      mOnSurface = "#ffffff";
      mSurfaceVariant = "#e6e6e6";
      mOnSurfaceVariant = "#b3b3b3";
      mHover = "#d0d0d0";
      mOnHover = "#ffffff";
      mOutline = "#cccccc";
      mShadow = "#000000";
    };
  };
}
