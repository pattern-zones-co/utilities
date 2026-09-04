{
  description = "coedit — Pattern Zones internal CLI (binary release)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      version = "1.2.1";

      # coedit is deployed only to linux/amd64 workstations, and upstream
      # goreleaser now builds that target alone. Listing a system here without a
      # published tarball would fail at fetch time with a 404 rather than a
      # clear "unsupported system", so the list tracks what actually ships.
      assets = {
        "x86_64-linux" = { arch = "linux_amd64"; hash = "sha256-LAPFPK2FBlOgd1PCVwwkFNQtu+CfUspPipQocHObrT4="; };
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
