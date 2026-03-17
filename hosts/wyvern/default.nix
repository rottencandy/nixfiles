{
  nixpkgs,
  home-manager,
  paisa,
  cloudypad,
  inputs,
  ...
}:

nixpkgs.lib.nixosSystem {
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.backupFileExtension = "backup";
      home-manager.users.saud = {
        imports = [
          (import ./home.nix {
            paisa = paisa;
            cloudypad = cloudypad;
          })
        ];
      };
    }
  ];
  specialArgs = {
    inherit inputs;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
