# Shared config for all VMs.
{ ... }:
{
  programs.bash.interactiveShellInit = ''
    bind '"\e[5~": history-search-backward'
    bind '"\e[6~": history-search-forward'
  '';
}
