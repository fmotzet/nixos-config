{ ... }:
{
  programs.git.settings.user.email = "felix.motzet@gmail.com";
  programs.git.includes = [
    {
      condition = "hasconfig:remote.*.url:git@gitlab.boerse-go.de:*";
      contents.user.email = "felix.motzet@stock3.com";
    }
  ];
}
