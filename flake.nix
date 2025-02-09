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
          mkdir -p $out
          echo "DEBUG: Listing contents of local source (./.):"
          ls -la ${./.}

          echo "Copying local source contents to \$out"
          cp -r ${./.}/* $out || true

          echo "DEBUG: Listing contents of theme folder:"
          ls -la ${theme.packages.${system}.theme} || true

          echo "Copying theme contents to \$out"
          mkdir $out/theme
          cp -r ${theme.packages.${system}.theme}/* $out/theme/ || true
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

