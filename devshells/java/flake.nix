{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdk17
            maven
            jetbrains.idea-community
          ];

          shellHook = ''
            export JAVA_HOME=${pkgs.jdk17}
            export JDK_HOME=${pkgs.jdk17}
            PATH="${pkgs.jdk17}/bin:$PATH"
          '';
        };
      });
}
