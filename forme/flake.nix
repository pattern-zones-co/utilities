{
  description = "forme — Pattern Zones internal CLI (binary release)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      version = "0.2.0";

      assets = {
        "x86_64-linux"   = { arch = "linux_amd64";   hash = "sha256-wB4AZK7uK0LHkE0N90U9E6YWrls7O1SvfUspWubrs38="; };
        "aarch64-linux"  = { arch = "linux_arm64";   hash = "sha256-cJWkg/frqHab4r6lHfRazIlPZwRtyICS0sA9RK4goPo="; };
        "x86_64-darwin"  = { arch = "darwin_amd64";  hash = "sha256-vqztaj48kzFEQ7i8/hjvnlJ7YVtoCmYxNYNKo7XD+t4="; };
        "aarch64-darwin" = { arch = "darwin_arm64";  hash = "sha256-frAE4mgIiuNVPz1ooGcWVpGCf9HFyR5wIzSZfNwIHqA="; };
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
