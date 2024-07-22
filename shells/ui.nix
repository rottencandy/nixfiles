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

  #nativeBuildInputs = with pkgs; [ playwright-driver.browsers ];

  #shellHook = ''
  #  export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
  #  export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
  #'';
}

# vim: fdm=marker:fdl=0:et:sw=2
