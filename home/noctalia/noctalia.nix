{ ... }:
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "top";
      };
      general.avatarImage = ./nixos-baw.png;
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
