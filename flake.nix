{
  description = "The great Nix configuration.";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

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

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
    };

    llama = {
      url = "github:ggml-org/llama.cpp";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
  };

  outputs =
    {
      nix-darwin,
      nixpkgs,
      home-manager,
      rust-overlay,
      sops-nix,
      nixgl,
      llama,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        "dunworthy" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
              rust-overlay.overlays.default
              llama.overlays.default
            ];
          };

          modules = [
            ./hosts/dunworthy.nix

            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/dunworthy.nix;
            }
          ];
        };

        "grendel" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";

          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config.allowUnfree = true;
            overlays = [ rust-overlay.overlays.default ];
          };

          modules = [
            ./hosts/grendel.nix

            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/grendel.nix;
            }
          ];
        };

        "vultr-vpn" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ rust-overlay.overlays.default ];
          };

          modules = [
            ./hosts/vultr-vpn.nix

            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/vultr-vpn.nix;
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

            sops-nix.nixosModules.sops
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
            overlays = [
              rust-overlay.overlays.default
              nixgl.overlay
            ];
          };

          modules = [
            ./home-manager/oliver.nix
            sops-nix.homeManagerModules.sops
          ];

          extraSpecialArgs = {
            inherit nixgl;
            inherit inputs;
          };
        };

        "awick@graf" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ rust-overlay.overlays.default ];
          };

          modules = [
            ./home-manager/graf.nix
            sops-nix.homeManagerModules.sops
          ];
        };
      };
    };
}
