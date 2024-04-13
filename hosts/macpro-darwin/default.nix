{
  nix-darwin,
  home-manager,
  inputs,
  ...
}:

nix-darwin.lib.darwinSystem {
  modules = [
    ./configuration.nix
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.users.msaud = {
        imports = [ ./home.nix ];
      };
    }
  ];
  specialArgs = {
    inherit inputs;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
