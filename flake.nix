{
  description = "my nixos configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }: 
    let
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
    nixosConfigurations.nixos-TP-p15v = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/nixos-TP-p15v/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
          }
        ];
    };
  };
}
