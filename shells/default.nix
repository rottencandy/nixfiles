{
  nixpkgs,
  system,
  inputs,
  pkgs,
  ...
}:

{
  "${system}" = {
    ui = import ./ui.nix {
      inherit
        nixpkgs
        system
        inputs
        pkgs
        ;
    };
    backend = import ./hermes.nix {
      inherit
        nixpkgs
        system
        inputs
        pkgs
        ;
    };
    py = import ./py.nix {
      inherit
        nixpkgs
        system
        inputs
        pkgs
        ;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
