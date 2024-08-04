{
  description = "The great Nix configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nix-darwin, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      "testvm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
        ];
      };
    };

    darwinConfigurations = {
      "ergates" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/ergates-darwin.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.users.adamwick = import ./hosts/ergates.nix;
          }
        ];
      };
    };

    homeConfigurations = {
    };
  };
}
