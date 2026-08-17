{
  description = "coedit — Pattern Zones internal CLI (binary release)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      version = "1.1.0";

      assets = {
        "x86_64-linux"   = { arch = "linux_amd64";   hash = "sha256-cFuUU4bbubR2E7ZplWGEKFvAumlhXhb9G+39pz/W/Mg="; };
        "aarch64-linux"  = { arch = "linux_arm64";   hash = "sha256-IV0brkFo17A/Dp2NLNhoZsIot/jrQFrqs7JTJNPPlTA="; };
        "x86_64-darwin"  = { arch = "darwin_amd64";  hash = "sha256-unLmjhTkAdhAEaSjLryb5+vwbDqJXf9FDi2aHE9/f/I="; };
        "aarch64-darwin" = { arch = "darwin_arm64";  hash = "sha256-CuRdXtiJZHw579Ikp9UTuoKuLWoW3heXnOMs+BA3+/4="; };
      };

      # coedit shells out to a bare `typst` resolved from PATH, so it is
      # deliberately NOT wrapped with a typst from this flake's nixpkgs: 24.11
      # ships typst 0.12.x, and consumers (e.g. devbox) pin a newer typst on
      # purpose. Wrapping here would silently downgrade the compiler.
      mkPackage = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          asset = assets.${system};
        in
        pkgs.stdenv.mkDerivation {
          pname = "coedit";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://github.com/pattern-zones-co/utilities/releases/download/coedit-v${version}/coedit_${version}_${asset.arch}.tar.gz";
            hash = asset.hash;
          };
          sourceRoot = ".";
          installPhase = ''
            install -Dm755 coedit $out/bin/coedit
          '';
        };
    in
    {
      packages = nixpkgs.lib.genAttrs (builtins.attrNames assets) (system: rec {
        default = mkPackage system;
        coedit = default;
      });
    };
}
