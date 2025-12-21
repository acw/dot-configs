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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comfyui = {
      url = "github:acw/comfyui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nix-darwin,
      nixpkgs,
      home-manager,
      rust-overlay,
      agenix,
      nixgl,
      comfyui,
      ...
    }@inputs:
      let standardPackages = system: import nixpkgs {
        system = system;
        config.allowUnfree = true;
        overlays = [ rust-overlay.overlays.default ];
      };

      in {
      nixosConfigurations = {
        "dunworthy" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = standardPackages "x86_64-linux";

          modules = [
            ./hosts/dunworthy.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/dunworthy.nix;
              home-manager.extraSpecialArgs = {
                systemUse = "personal";
              };
            }
          ];
        };

        "mensah" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = standardPackages "x86_64-linux";

          specialArgs = {
            tailscaleModes = [ ];
            inherit comfyui;
          };

          modules = [
            agenix.nixosModules.default

            ./hosts/mensah.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [ agenix.homeManagerModules.default ];
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/mensah.nix;
              home-manager.extraSpecialArgs = {
                systemUse = "personal";
              };
            }
          ];
        };

        "grendel" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = standardPackages "aarch64-linux";

          specialArgs = {
            tailscaleModes = [
              "exit"
              "webserver"
            ];
          };

          modules = [
            ./hosts/grendel.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/grendel.nix;
              home-manager.extraSpecialArgs = {
                systemUse = "functional";
              };
            }
          ];
        };

        "http-origin" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = standardPackages "x86_64-linux";

          specialArgs = {
	        tailscaleModes = [ "webserver" ];
          };

          modules = [
            ./hosts/http-origin.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/http-origin.nix;
              home-manager.extraSpecialArgs = {
                systemUse = "functional";
              };
            }
          ];
        };

        "vultr-vpn" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = standardPackages "x86_64-linux";

          specialArgs = {
            tailscaleModes = [ "exit" ];
          };

          modules = [
            ./hosts/vultr-vpn.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.awick = import ./home-manager/vultr-vpn.nix;
              home-manager.extraSpecialArgs = {
                systemUse = "functional";
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        "ergates" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = standardPackages "aarch64-darwin";

          modules = [
            ./hosts/ergates.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.sharedModules = [ agenix.homeManagerModules.default ];
              home-manager.useGlobalPkgs = true;
              home-manager.users.adamwick = import ./home-manager/ergates.nix;
              home-manager.extraSpecialArgs = {
                systemUse = "personal";
              };
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
          ];

          extraSpecialArgs = {
            inherit nixgl;
            inherit inputs;

            systemUse = "work";
            tailscaleModes = [ ];
          };
        };

        "awick@graf" = home-manager.lib.homeManagerConfiguration {
          pkgs = standardPackages "x86_64-linux";

          modules = [
            ./home-manager/graf.nix
          ];

          extraSpecialArgs = {
            systemUse = "work";
            tailscaleModes = [ ];
          };
        };
      };
    };
}
