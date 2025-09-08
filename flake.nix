{
  description = "The great Nix configuration.";

  inputs = {
    self.submodules = true;

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
      sops-nix,
      nixgl,
      comfyui,
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
            ];
          };

          modules = [
            ./hosts/dunworthy.nix

            sops-nix.nixosModules.sops
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

          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;

            overlays = [
              rust-overlay.overlays.default
            ];
          };

          specialArgs = {
            tailscaleModes = [ ];
            inherit comfyui;
          };

          modules = [
            ./hosts/mensah.nix

            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
              home-manager.users.awick = import ./home-manager/mensah.nix;
              home-manager.extraSpecialArgs = {
                systemUse = "personal";
              };
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

          specialArgs = {
            tailscaleModes = [ "exit" "webserver" ];
          };

          modules = [
            ./hosts/grendel.nix

            sops-nix.nixosModules.sops
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

        "vultr-vpn" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            tailscaleModes = [ "exit" ];
          };

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
              home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
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
            sops-nix.homeManagerModules.sops
          ];

          extraSpecialArgs = {
            inherit nixgl;
            inherit inputs;

            systemUse = "work";
            tailscaleModes = [];
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

          extraSpecialArgs = {
            systemUse = "work";
            tailscaleModes = [];
          };
        };
      };
    };
}
