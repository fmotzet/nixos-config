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
  users.users.motzworks = {
    isNormalUser = true;
    shell = pkgs.bash;
  };
}
