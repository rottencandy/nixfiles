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
    nodejs_22

    nodePackages.yarn
    vscode-langservers-extracted
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
