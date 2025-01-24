{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    forester.url = "sourcehut:~jonsterling/ocaml-forester";
  };

  outputs = { self, nixpkgs, flake-utils, forester }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "forest-website";
        src = ./.;
        
        nativeBuildInputs = [
          forester.packages.${system}.default
          pkgs.nodePackages.katex  # Required by forester
        ];

        buildPhase = ''
          export HOME=$TMPDIR  # Clean environment
          forester build forest.toml
        '';
        
        installPhase = ''
          mkdir -p $out
          cp -r output/* $out/
        '';
      };
    });
}
