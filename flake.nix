{
  description = "The great Nix configuration.";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nix-darwin, nixpkgs, home-manager, rust-overlay, ... }: {
    nixosConfigurations = {
      "testvm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [ rust-overlay.overlays.default ];
        };

        modules = [
          ./hosts/dunworthy.nix
          ./containers/mosquitto.nix
          ./containers/tailscale.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.adamwick = import ./home-manager/dunworthy.nix;
          }
        ];
      };
    };

    darwinConfigurations = {
      "ergates" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [ rust-overlay.overlays.default ];
        };

        modules = [
          ./hosts/ergates.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.adamwick = import ./home-manager/ergates.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      "awick@oliver" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ rust-overlay.overlays.default ];
        };

        modules = [ ./home-manager/oliver.nix ];
      };

      "awick@graf" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ rust-overlay.overlays.default ];
        };

        modules = [ ./home-manager/graf.nix ];
      };
    };
  };
}
