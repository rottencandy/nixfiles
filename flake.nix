{
  description = "saud's nixOS configurations";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration_dev0.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            users.saud = {
              imports = [ ./home/common.nix ];
            };
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };

    darwinConfigurations."msaud-mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/macpro-darwin/configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.users.msaud = {
            imports = [ ./hosts/macpro-darwin/home.nix ];
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
