{
  inputs,
  ...
}:

inputs.nixpkgs.lib.nixosSystem {
  modules = with inputs; [
    musnix.nixosModules.musnix
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.saud = {
        imports = [
          ./home.nix
        ];
      };
    }
  ];
  specialArgs = {
    inherit inputs;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
