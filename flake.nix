{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-xivlauncher-rb = {
      url = "github:drakon64/nixos-xivlauncher-rb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # caelestia = {
    #   url = "github:caelestia-dots/shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    more-waita = {
      url = "github:somepaulo/MoreWaita";
      flake = false;
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        username = "andris";
        hostname = "home";
      };
      modules = [
        ./hosts/home/configuration.nix
      ];
    };
    nixosConfigurations.work = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        username = "andris";
        hostname = "work";
      };
      modules = [
        ./hosts/work/configuration.nix
      ];
    };
    nixosConfigurations.nova = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        username = "andris";
        hostname = "nova";
      };
      modules = [
        ./hosts/nova/configuration.nix
      ];
    };
  };
}
