{ ... }:
let
  personalEmail = "felix.motzet@gmail.com";
  workEmail = "felix.motzet@stock3.com";
  workRemotePatterns = [
    "*://*gitlab.boerse-go.de*/**"
    "*gitlab.boerse-go.de*/**"
  ];
in
{
  programs.git.settings.user.email = personalEmail;

  programs.git.includes = map (pattern: {
    condition = "hasconfig:remote.*.url:${pattern}";
    contents.user.email = workEmail;
  }) workRemotePatterns;
}