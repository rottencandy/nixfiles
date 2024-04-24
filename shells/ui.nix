{
  nixpkgs,
  inputs,
  system,
  pkgs,
  ...
}:

pkgs.mkShell {
  packages = with pkgs; [
    deno
    nodejs_20
    nodePackages.yarn
    vscode-langservers-extracted
    nodePackages.typescript-language-server
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
