{
  description = "unslop — Pattern Zones internal CLI (binary release)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      version = "1.1.0";

      # Upstream releases include the `v` prefix in asset filenames.
      # Only x86_64-linux and aarch64-darwin are published today; add others
      # as upstream produces them.
      assets = {
        "x86_64-linux"   = { arch = "linux_amd64";  hash = "sha256-4fAbgwsE2bVOJjz3jPxiIZv2Wj6+nBGn3VZDgDjQP2k="; };
        "aarch64-darwin" = { arch = "darwin_arm64"; hash = "sha256-pPYTF95/jjwg9Lt/ze8OTFmPMGfMyuuczEPLlUz4Luc="; };
      };

      mkPackage = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          asset = assets.${system};
        in
        pkgs.stdenv.mkDerivation {
          pname = "unslop";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://github.com/pattern-zones-co/utilities/releases/download/unslop-v${version}/unslop_v${version}_${asset.arch}.tar.gz";
            hash = asset.hash;
          };
          sourceRoot = ".";
          installPhase = ''
            install -Dm755 unslop $out/bin/unslop
          '';
        };
    in
    {
      packages = nixpkgs.lib.genAttrs (builtins.attrNames assets) (system: rec {
        default = mkPackage system;
        unslop = default;
      });
    };
}
