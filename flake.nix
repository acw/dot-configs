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
    let
      standardPackages =
        system:
        import nixpkgs {
          system = system;
          config.allowUnfree = true;
          overlays = [ rust-overlay.overlays.default ];
        };

      standardHomeManager = import ./lib/home-manager.nix inputs;

      mkNixosSystem =
        {
          system,
          hostConfig,
          use,
          user ? "awick",
          gui ? false,
          tailscaleModes ? [ ],
          enableAgenix ? false,
          extraSpecialArgs ? { },
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem rec {
          inherit system;
          pkgs = standardPackages system;

          specialArgs = {
            inherit tailscaleModes;
          }
          // extraSpecialArgs;

          modules = [
            hostConfig
          ]
          ++ (if enableAgenix then [ agenix.nixosModules.default ] else [ ])
          ++ [
            home-manager.nixosModules.home-manager
            (standardHomeManager pkgs { inherit user use gui; })
          ]
          ++ extraModules;
        };

      mkDarwinSystem =
        {
          system,
          hostConfig,
          use,
          user ? "adamwick",
          gui ? false,
          extraModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem rec {
          inherit system;
          pkgs = standardPackages system;

          modules = [
            hostConfig
            home-manager.darwinModules.home-manager
            (standardHomeManager pkgs { inherit user use gui; })
          ]
          ++ extraModules;
        };

    in
    {
      nixosConfigurations = {
        "dunworthy" = mkNixosSystem {
          system = "x86_64-linux";
          hostConfig = ./hosts/dunworthy.nix;
          use = "personal";
          enableAgenix = true;
        };

        "mensah" = mkNixosSystem {
          system = "x86_64-linux";
          hostConfig = ./hosts/mensah.nix;
          use = "personal";
          enableAgenix = true;
          extraSpecialArgs = { inherit comfyui; };
        };

        "grendel" = mkNixosSystem {
          system = "aarch64-linux";
          hostConfig = ./hosts/grendel.nix;
          use = "infrastructure";
          tailscaleModes = [
            "exit"
            "webserver"
          ];
        };

        "http-origin" = mkNixosSystem {
          system = "x86_64-linux";
          hostConfig = ./hosts/http-origin.nix;
          use = "infrastructure";
          enableAgenix = true;
          tailscaleModes = [ "webserver" ];
        };

        "vultr-vpn" = mkNixosSystem {
          system = "x86_64-linux";
          hostConfig = ./hosts/vultr-vpn.nix;
          use = "infrastructure";
          tailscaleModes = [ "exit" ];
        };
      };

      darwinConfigurations = {
        "ergates" = mkDarwinSystem {
          system = "aarch64-darwin";
          hostConfig = ./hosts/ergates.nix;
          user = "adamwick";
          use = "personal";
          gui = true;
        };
      };

      homeConfigurations = {
        "awick@oliver" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
              rust-overlay.overlays.default
              nixgl.overlay
            ];
          };

          modules = [
            agenix.homeManagerModules.default
            (standardHomeManager pkgs {
              use = "work";
              gui = true;
            }).home-manager.users.awick
          ];

          extraSpecialArgs = {
            inherit nixgl;
            inherit inputs;

            systemUse = "work";
            tailscaleModes = [ ];
          };
        };

        "awick@graf" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = standardPackages "x86_64-linux";

          modules = [
            agenix.homeManagerModules.default
            (standardHomeManager pkgs {
              use = "work";
              gui = false;
            }).home-manager.users.awick
          ];

          extraSpecialArgs = {
            systemUse = "work";
            tailscaleModes = [ ];
          };
        };
      };
    };
}
