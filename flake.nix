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

    nix-gaming.url = "github:fufexan/nix-gaming";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=0f594732b063a90d44df8c5d402d658f27471dfe"; /* 0.43.0 */

    more-waita = {
      url = "github:somepaulo/MoreWaita";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    {
      nixosConfigurations.home = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/home/configuration.nix
          # hyprland.nixosModules.default
        ];
      };
    };
}
