{
  description = "forme — Pattern Zones internal CLI (binary release)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      version = "0.2.1";

      assets = {
        "x86_64-linux"   = { arch = "linux_amd64";   hash = "sha256-c51OufXUmlox1ou3t4Mu9gZT3SaC8eH3SExqxHuI4hw="; };
        "aarch64-linux"  = { arch = "linux_arm64";   hash = "sha256-3kGED0Vw41u83A66zrWbi91miXtRea7XWsKT8kPTVFs="; };
        "x86_64-darwin"  = { arch = "darwin_amd64";  hash = "sha256-WXIj4dgo7l85+zd9jb3CNjeRAETcUy89NeJeE5vVYdE="; };
        "aarch64-darwin" = { arch = "darwin_arm64";  hash = "sha256-0CaOLwH4xtw1PGr3sdzd3+r18heEvbHvvvolvnK6abQ="; };
      };

      mkPackage = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          asset = assets.${system};
        in
        pkgs.stdenv.mkDerivation {
          pname = "forme";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://github.com/pattern-zones-co/utilities/releases/download/forme-v${version}/forme_${version}_${asset.arch}.tar.gz";
            hash = asset.hash;
          };
          sourceRoot = ".";
          installPhase = ''
            install -Dm755 forme $out/bin/forme
          '';
        };
    in
    {
      packages = nixpkgs.lib.genAttrs (builtins.attrNames assets) (system: rec {
        default = mkPackage system;
        forme = default;
      });
    };
}
