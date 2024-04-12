{
  description = "saud's nixOS configurations";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
    }:
    {
      nixosConfigurations.nixos = import ./hosts/asus-linux {
        inherit
          self
          nixpkgs
          home-manager
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

      # todo: make this platform-independent
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

# vim: fdm=marker:fdl=0:et:sw=2
