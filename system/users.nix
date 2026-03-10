{ pkgs, ... }:
{
  users.users.felix = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
    ]; 
    packages = with pkgs; [
      tree
    ];
  };
}
