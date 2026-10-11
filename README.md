# nixos-config  

### Build locally push system to host 
*saves diskspace on remote*
using passowrd prompt:
`nixos-rebuild switch --flake .#dawarich01 --target-host felix@dawarich01 --sudo --ask-sudo-password`

### Cleanup Nix Storage:  
Delete old Generations:  
`sudo nix-collect-garbage --delete-older-than 7d`  
Cleanup Nix store:
`nix-store --optimize`  
Then rebuild