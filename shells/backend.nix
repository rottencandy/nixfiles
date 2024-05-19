{
  nixpkgs,
  inputs,
  system,
  pkgs,
  ...
}:

pkgs.mkShell {
  packages = with pkgs; [
    go_1_22
    rustup
    gopls

    just
    buf

    jack2
    alsa-lib
    openssl
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
