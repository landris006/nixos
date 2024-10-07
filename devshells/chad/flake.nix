{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        with pkgs; {
          devShells.default = mkShell.override { stdenv = gcc14Stdenv; }
            rec {
              buildInputs = [
                gcc14
                clang-tools
                cpplint

                bear

                renderdoc

                # udev
                # alsa-lib
                # glslang
                shaderc
                vulkan-headers
                vulkan-loader
                vulkan-tools
                vulkan-validation-layers

                glfw
                glm

                libxkbcommon
                libGL

                wayland

                xorg.libXcursor
                xorg.libXrandr
                xorg.libXi
                xorg.libX11
                xorg.libXxf86vm
              ];

              VULKAN_SDK = "${vulkan-headers}";
              VK_LAYER_PATH = "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";
              LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
            };
        }
      );
}
