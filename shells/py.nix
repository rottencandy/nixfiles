{
  pkgs,
  ...
}:

pkgs.mkShell {
  packages = with pkgs; [
    python3
    basedpyright
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
