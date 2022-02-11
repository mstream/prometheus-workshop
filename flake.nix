{
  description = "Prometheus Workshop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-compat, flake-utils, nixpkgs, self }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          buildInputs = with pkgs; [
            docker
            docker-compose
          ];
          shellHook = ''
            PS1="\[\e[33m\][\[\e[m\]\[\e[34;40m\]prometheus-workshop:\[\e[m\]\[\e[36m\]\w\[\e[m\]\[\e[33m\]]\[\e[m\]\[\e[32m\]\\$\[\e[m\] "
          '';
        in
        {
          devShell = pkgs.mkShell {
            inherit buildInputs;
            inherit shellHook;
          };

          defaultPackage = pkgs.stdenv.mkDerivation {
            name = "prometheus-workshop";
            src = self;
            buildPhase = "";
            installPhase = "mkdir $out";
          };
        }
      );
}
