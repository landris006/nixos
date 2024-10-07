{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        devShells = {
          node-22 = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_22
            ];
          };
          node-18 = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_18
              ember-cli
              yarn
            ];
            shellHook = ''
              PATH="$PATH:$HOME/src/dbx/moby-scripts:$HOME/src/dbx/moby-mpb/scripts"
            '';
          };
          default = devShells.node-22;
        };
      });
}
