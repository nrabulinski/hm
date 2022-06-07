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

  outputs = { nixpkgs, home-manager, fenix, ... }:
    let
      system = "x86_64-linux";
      username = "nixos";
      hmConfig = with nixpkgs.lib; {
        rust ? false,
        sway ? false
      }: { ... }: {
        imports = [
          ./home-manager/home.nix
        ] 
        ++ optional rust ./home-manager/rust.nix
        ++ optional sway ./home-manager/sway.nix;
      };
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          configuration = hmConfig { rust = true; };

          inherit system username;
          homeDirectory = "/home/${username}";
          stateVersion = "22.05";
          extraSpecialArgs = { inherit fenix; };
        };
        
      
      nixosConfigurations.virtualBox = nixpkgs.lib.nixosSystem {
        inherit system;
        
        modules = [
          ./nixos/virtualBox.nix
          ({ ... }: { nixpkgs.overlays = [ fenix.overlay ]; })
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = hmConfig { 
              rust = true; 
              sway = true; 
            };
          } 
        ];
      };
    };
}
