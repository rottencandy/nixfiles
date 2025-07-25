{
  description = "saud's nixOS configurations";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paisa = {
      url = "github:ananthakumaran/paisa";
      inputs.hledger-pkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      ghostty,
      paisa,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      nixosConfigurations.wyvern = import ./hosts/wyvern {
        inherit
          self
          nixpkgs
          home-manager
          ghostty
          paisa
          inputs
          ;
      };

      nixosConfigurations.kitsune = import ./hosts/kitsune {
        inherit
          self
          nixpkgs
          home-manager
          ghostty
          paisa
          inputs
          ;
      };

      darwinConfigurations.msaud-mac = import ./hosts/macpro-darwin {
        inherit
          self
          nixpkgs
          nix-darwin
          home-manager
          inputs
          ;
      };

      formatter."${system}" = nixpkgs.legacyPackages."${system}".nixfmt-rfc-style;

      devShells = import ./shells {
        inherit
          self
          nixpkgs
          system
          inputs
          pkgs
          ;
      };
    };
}

# vim: fdm=marker:fdl=0:et:sw=2
