{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    utils,
    ...
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      java = pkgs.jdk21;
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          java
          maven
          gradle
        ];

        shellHook = ''
          export JAVA_HOME=${java}
          export JDK_HOME=${java}
          PATH="${java}/bin:$PATH"
        '';
      };
    });
}
