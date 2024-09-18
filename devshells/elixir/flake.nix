{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/698fd43e541a6b8685ed408aaf7a63561018f9f8";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells = {
          default = with pkgs; mkShell {
            buildInputs = [
              elixir
              elixir-ls
              emmet-ls
            ];
          };
        };
      }
    );
}
