{
  description = "Nixos COnfiguration flake for host nixos-TP-p15v";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos-TP-p15v = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/nixos-TP-p15v/configuration.nix
          home-manager.nixosModules.home-manager
        ];
    };
  };
}
