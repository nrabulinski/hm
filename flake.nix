{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, fenix, ... }:
    let
      system = "x86_64-linux";
      username = "nixos";
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          configuration = import ./home.nix;

          inherit system username;
          homeDirectory = "/home/${username}";
          stateVersion = "22.05";
          extraSpecialArgs = { inherit fenix; };
        };
    };
}
