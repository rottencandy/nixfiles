{
  pkgs,
  ...
}:

pkgs.mkShell {
  packages = with pkgs; [
    go_1_24
    rustup
    gopls
    rust-analyzer-unwrapped

    just
    buf

    jack2
    alsa-lib
    openssl
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
