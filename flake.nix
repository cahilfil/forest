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
      devShells.${system}.default =
        pkgs.mkShell { buildInputs = [ forester.packages.${system}.default ]; };

      packages.${system}.site = pkgs.stdenv.mkDerivation {
        name = "my-static-site";
        src = pkgs.runCommand "merged-src" { } ''
          echo $out
          mkdir -p $out
          ls -la $out
          cp -r ${./.}/* $out 
          ls -la $out
          echo "a"
          rm -rf $out/theme 
          echo "b"
          ls -la $out
          echo ${theme.packages.${system}.theme}
          cp -rf ${theme.packages.${system}.theme} $out/
          ls -la $out/theme
        '';

        buildInputs = [ forester.packages.${system}.default ];
        buildPhase = ''
          forester build forest.toml
        '';
        installPhase = ''
          cp -r output $out
        '';
      };
    };
}

