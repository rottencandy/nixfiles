{
  nixpkgs,
  inputs,
  system,
  pkgs,
  ...
}:

let

  nodejs = pkgs.nodejs_24;
  # Adding libuuid to some node binaries are required by the
  # "node-canvas" package
  wrapWithMissingLibraries =
    binaryFile:
    pkgs.writeShellScriptBin (baseNameOf binaryFile) ''
      LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.libuuid ]}";
      export LD_LIBRARY_PATH
      exec ${binaryFile} "$@";
    '';
  node = (wrapWithMissingLibraries (pkgs.lib.getExe nodejs));
  #yarn = wrapWithMissingLibraries (pkgs.lib.getExe pkgs.yarn);

in

pkgs.mkShell {
  packages = with pkgs; [
    #deno
    nodejs
    node
    bun

    nodePackages.yarn
    vscode-langservers-extracted
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server

    grpcurl
  ];

  #nativeBuildInputs = with pkgs; [ playwright-driver.browsers ];

  #shellHook = ''
  #  export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
  #  export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
  #'';
}

# vim: fdm=marker:fdl=0:et:sw=2
