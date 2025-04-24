{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            zip
            pam
          ];

          shellHook = ''
            # Install NVM if it's not present
            export NVM_DIR="$HOME/.nvm"
            if [ ! -d "$NVM_DIR" ]; then
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
              . "$NVM_DIR/nvm.sh"
            fi

            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

            # Install SDKMAN if not present
            export SDKMAN_DIR="$HOME/.sdkman"
            if [ ! -d "$SDKMAN_DIR" ]; then
              curl -s "https://get.sdkman.io" | bash
            fi
            source "$SDKMAN_DIR/bin/sdkman-init.sh"

            export PATH="$PATH:$HOME/src/dbx/moby.scripts"
          '';
        };
      }
    );
}
