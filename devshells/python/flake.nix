{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    nixpkgs,
    utils,
    ...
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in
      with pkgs; {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            python312
            python312Packages.pip
            ghostscript
            poppler-utils
          ];

          shellHook = ''
            VENV=.venv

            if test ! -d $VENV; then
              ${pkgs.python312}/bin/python -m venv $VENV
            fi
            source ./$VENV/bin/activate

            export PYTHONPATH=`pwd`/$VENV/${pkgs.python312.sitePackages}/:$PYTHONPATH

            # pip install -r requirements.txt
          '';

          GMT_LIBRARY_PATH = "${pkgs.gmt}/lib";
          LD_LIBRARY_PATH = lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib # libstdc++
            pkgs.zlib # libz
            pkgs.libGL # libGL (needed by matplotlib)
            pkgs.glib # libglib
          ];
        };
      });
}
