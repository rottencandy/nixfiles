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
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    paisa = {
      url = "github:ananthakumaran/paisa";
      inputs.mkdocs-pkgs.follows = "nixpkgs";
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
      nixosConfigurations.nixos = import ./hosts/asus-linux {
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

      formatter."${system}" = pkgs.nixfmt-rfc-style;

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
