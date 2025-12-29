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

          standardHomeManager = import ./lib/home-manager.nix inputs; 

      in {
      nixosConfigurations = {
        "dunworthy" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = standardPackages "x86_64-linux";

          modules = [
            ./hosts/dunworthy.nix

            home-manager.nixosModules.home-manager
              (standardHomeManager pkgs { use = "personal"; })
          ];
        };

        "mensah" = nixpkgs.lib.nixosSystem rec {
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
              (standardHomeManager pkgs { use = "personal"; })
          ];
        };

        "grendel" = nixpkgs.lib.nixosSystem rec {
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
              (standardHomeManager pkgs { use = "infrastructure"; })
          ];
        };

        "http-origin" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = standardPackages "x86_64-linux";

          specialArgs = {
	        tailscaleModes = [ "webserver" ];
          };

          modules = [
            ./hosts/http-origin.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
              (standardHomeManager pkgs { use = "infrastructure"; })
          ];
        };

        "vultr-vpn" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = standardPackages "x86_64-linux";

          specialArgs = {
            tailscaleModes = [ "exit" ];
          };

          modules = [
            ./hosts/vultr-vpn.nix

            home-manager.nixosModules.home-manager
              (standardHomeManager pkgs { use = "infrastructure"; })
          ];
        };
      };

      darwinConfigurations = {
        "ergates" = nix-darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          pkgs = standardPackages "aarch64-darwin";

          modules = [
            ./hosts/ergates.nix

            home-manager.darwinModules.home-manager
              (standardHomeManager pkgs {
                 user = "adamwick";
                 use = "personal";
                 gui = true;
              })
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
