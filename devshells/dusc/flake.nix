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
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          zig_0_15
          python312
          python312Packages.pip
          gcc-arm-embedded
          openocd
          gdb
          clang
          # cpplint
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
      };
    });
}
# python: openocd, pyelftools, pyyaml

