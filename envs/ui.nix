{
  description = "A flake.";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # unstable Nixpkgs

  outputs =
    { self, ... }@inputs:

    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.self.overlays.default ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: rec {
        nodejs = prev.nodejs;
      };

      packages = forEachSupportedSystem (
        { pkgs, ... }:
        let
          version = "1.4.4";
          bunUrl = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
          bunReleaseHash = "sha256-v4zL+ysLgBWeD5ptFcVTF63YB3U028YTCj7bUvzLOVw=";
        in
        {
          bun = pkgs.stdenv.mkDerivation {
            pname = "bun";
            inherit version;
            src = pkgs.fetchurl {
              url = bunUrl;
              sha256 = bunReleaseHash;
            };
            nativeBuildInputs = [
              pkgs.unzip
              pkgs.autoPatchelfHook
            ];
            buildInputs = with pkgs; [
              stdenv.cc.cc.lib
              openssl
              libuuid
            ];
            buildPhase = "true";
            installPhase = ''
              mkdir -p $out/bin
              unzip -j $src -d $out/bin
              chmod +x $out/bin/bun
            '';
            meta = with pkgs.lib; {
              description = "Bun runtime (wrapped upstream binary) v${version}";
              homepage = "https://bun.sh";
              license = licenses.mit;
            };
          };
        }
      );

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              nodejs
              self.packages.${pkgs.system}.bun
              deno

              vscode-langservers-extracted
              typescript
              typescript-language-server
            ];

            #LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            #  pkgs.libz
            #];
          };
        }
      );
    };
}
