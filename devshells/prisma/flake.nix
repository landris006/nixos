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
        devShell = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            nodePackages.prisma
          ];

          shellHook = with pkgs; ''
            export PRISMA_SCHEMA_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
            export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
            export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
            export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
            export PRISMA_FMT_BINARY="${prisma-engines}/bin/prisma-fmt"
          '';
        };
      });
}
