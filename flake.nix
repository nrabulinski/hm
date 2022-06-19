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

  outputs = {
    nixpkgs,
    home-manager,
    fenix,
    ...
  }: let
    system = "x86_64-linux";
    user = "niko";
    hmConfig = with nixpkgs.lib;
      {
        rust ? false,
        sway ? false,
        qute ? false,
        imports ? [],
      }: {...}: {
        imports =
          [
            ./home-manager/home.nix
          ]
          ++ optional rust ./home-manager/rust.nix
          ++ optional sway ./home-manager/sway.nix
          ++ optional qute ./home-manager/desktop/qute.nix
          ++ imports;
      };
  in {
    homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration {
      configuration = hmConfig {rust = true;};

      inherit system user;
      homeDirectory = "/home/${user}";
      stateVersion = "22.05";
      extraSpecialArgs = {inherit fenix;};
    };

    nixosConfigurations.virtualBox = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {inherit user;};

      modules = [
        ./nixos/virtualBox.nix
        ({...}: {nixpkgs.overlays = [fenix.overlay];})
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = hmConfig {
            rust = true;
            sway = true;
          };
        }
      ];
    };

    nixosConfigurations.legion = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {inherit user;};

      modules = [
        ./nixos/legion.nix
        ({...}: {nixpkgs.overlays = [fenix.overlay];})
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = hmConfig {
            rust = true;
            qute = true;
            imports = [
              ./home-manager/desktop/xorg/i3.nix
              ./home-manager/pijul.nix
              ({pkgs, ...}: {
                home.packages = with pkgs; [virt-manager];
              })
            ];
          };
        }
      ];
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
