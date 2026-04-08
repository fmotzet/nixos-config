# nixos-config

### Cleanup Nix Storage:
Delete old Generations:
`sudo nix-collect-garbage --delete-older-than 7d`
Cleanup Nix store
`nix-store --optimize`
Then rebuild