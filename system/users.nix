{ pkgs, ... }:
{
  users.users.felix = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "docker"
      "wireshark" 
    ]; 
    packages = with pkgs; [
      tree
    ];
  };
}
