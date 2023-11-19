{
  nixpkgs,
  home-manager,
  inputs,
  ...
}:

nixpkgs.lib.nixosSystem {
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.users.saud = {
        imports = [ ./home.nix ];
      };
    }
  ];
  specialArgs = { inherit inputs; };
}

# vim: fdm=marker:fdl=0:et:sw=2
