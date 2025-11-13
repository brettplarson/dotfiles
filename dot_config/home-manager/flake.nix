{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... }:
    let
      system = "x86_64-linux"; # Change to your system architecture
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.brett = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix catppuccin.homeModules.catppuccin ];
      };
    };
}
