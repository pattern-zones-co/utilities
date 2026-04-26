{
  description = "loopctl — Pattern Zones internal CLI (binary release)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      version = "0.4.0";

      assets = {
        "x86_64-linux"   = { arch = "linux_amd64";   hash = "sha256-8uCpeXOV4dk5/isxa4+0MLHXj3gvwx+bGkfPiq0Mpfo="; };
        "aarch64-linux"  = { arch = "linux_arm64";   hash = "sha256-g0B+O1TbDeST6kgeY838uVzwUM84bdqbxio5qtq0Gm8="; };
        "x86_64-darwin"  = { arch = "darwin_amd64";  hash = "sha256-91uQdx4sJnYjbuM7pDYuyQMsXnEQJQxncOkICuPEVlc="; };
        "aarch64-darwin" = { arch = "darwin_arm64";  hash = "sha256-NF+xcfY5Mbhz3DZkPqy5KvSu7REaC+3lK/TJ0mjY8So="; };
      };

      mkPackage = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          asset = assets.${system};
        in
        pkgs.stdenv.mkDerivation {
          pname = "loopctl";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://github.com/pattern-zones-co/utilities/releases/download/loopctl-v${version}/loopctl_${version}_${asset.arch}.tar.gz";
            hash = asset.hash;
          };
          sourceRoot = ".";
          installPhase = ''
            install -Dm755 loopctl $out/bin/loopctl
          '';
        };
    in
    {
      packages = nixpkgs.lib.genAttrs (builtins.attrNames assets) (system: rec {
        default = mkPackage system;
        loopctl = default;
      });
    };
}
