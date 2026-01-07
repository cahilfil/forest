{
  inputs = {
    forester.url = "sourcehut:~jonsterling/ocaml-forester";
    forester.inputs.nixpkgs.follows = "nixpkgs";
    theme.url = "github:cahilfil/forest-theme?ref=main";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, forester, theme, nixpkgs }:
    let
      pkgs = import nixpkgs { inherit system inputs; };
      system = "x86_64-linux";
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ forester.legacyPackages.${system}.forester ];
      };

      packages.${system}.site = pkgs.stdenv.mkDerivation {
        name = "my-static-site";
        src = pkgs.runCommand "merged-src" { } ''
          mkdir -p $out
          cp -r ${./.}/* $out
          mkdir $out/theme
          cp -rf ${theme.packages.${system}.theme}/* $out/theme/
          rm -f $out/theme/result
        '';

        buildInputs = [ forester.legacyPackages.${system}.forester ];
        buildPhase = ''
          forester build forest.toml
        '';
        installPhase = ''
          mkdir -p $out
          cp -r output/. $out/
        '';
      };
    };
}
