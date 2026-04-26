{
  description = "hat — Pattern Zones human-as-tool CLI (binary release)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      version = "0.5.0";

      assets = {
        "x86_64-linux"   = { arch = "linux_amd64";   hash = "sha256-9Y1jWndhknHfsPu/2JGpKGfj5LGek7ONSCefg7jh4gs="; };
        "aarch64-linux"  = { arch = "linux_arm64";   hash = "sha256-Ha9jokwi1VSONMUU1x0fDrfG3IEGCj8mG/e3RnI9lv4="; };
        "x86_64-darwin"  = { arch = "darwin_amd64";  hash = "sha256-u+iAFrOogmlYwPQDzW3ufyoVhi37kOfTkWNM90dg56U="; };
        "aarch64-darwin" = { arch = "darwin_arm64";  hash = "sha256-Kja27po2rE8G/gu8bf+lYtBmywSJOl+PsskFzllyAcM="; };
      };

      mkPackage = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          asset = assets.${system};
        in
        pkgs.stdenv.mkDerivation {
          pname = "hat";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://github.com/pattern-zones-co/utilities/releases/download/hat-v${version}/hat_${version}_${asset.arch}.tar.gz";
            hash = asset.hash;
          };
          sourceRoot = ".";
          installPhase = ''
            install -Dm755 hat $out/bin/hat
          '';
        };
    in
    {
      packages = nixpkgs.lib.genAttrs (builtins.attrNames assets) (system: rec {
        default = mkPackage system;
        hat = default;
      });
    };
}
