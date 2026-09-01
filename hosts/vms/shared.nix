# Shared config for all VMs.
{ ... }:
{
  programs.bash.interactiveShellInit = ''
    bind '"\e[5~": history-search-backward'
    bind '"\e[6~": history-search-forward'
  '';

  # as i give vms small disks i have to make them run the garbage collector more automatically
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
}
