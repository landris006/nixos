{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      java = pkgs.jdk21;
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          java
          maven
          jetbrains.idea-community
        ];

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
          pkgs.openssl
          pkgs.linux-pam
        ];

        shellHook = ''
          export JAVA_HOME=${java}
          export JDK_HOME=${java}
          PATH="${java}/bin:$PATH"
        '';
      };
    });
}
