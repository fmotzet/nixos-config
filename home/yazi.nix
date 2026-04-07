{ ... }:
{
  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        show_hidden = true;
        ratio = [3 3 3]
      };
    };
  };
}