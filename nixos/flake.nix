{
  description = "Nix system configuration by gabri";

  inputs = {
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-patch-nvidia-615 = {
      url = "https://github.com/NixOS/nixpkgs/pull/561660.diff";
      flake = false;
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      winapps,
      nixpkgs-patcher,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        currentSystem = system;
        config = {
          nvidia.acceptLicense = true;
          allowUnfree = true;
        };
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations.minimus =
        let args = {
          host = "minimus";
          battery = true;
          dotfiles = "/home/gabri/.dotfiles";
          inherit inputs system;
        }; in
        nixpkgs-patcher.lib.nixosSystem {
        system = "x86_64-linux";
        nixpkgsPatcher.inputs = inputs;
        specialArgs = args;
        modules = [
          ./configuration.nix
          ./hyprland.nix
          { hyprlandConfig.battery = true; }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = args;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.gabri = {
                imports = [
                  ./home/home.nix
                ];
              };
            };
          }
        ];
      };
      nixosConfigurations.furunculus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          host = "furunculus";
          battery = true;
          inherit inputs system;
        };
        modules = [
          ./configuration.nix
          ./hyprland.nix
          { hyprlandConfig.battery = true; }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                host = "furunculus";
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.gabri = {
                imports = [
                  ./home/home.nix
                ];
              };
            };
          }
        ];
      };
      nixosConfigurations.DominusOmnium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          host = "DominusOmnium";
          inherit inputs system;
          battery = true;
        };
        modules = [
          ./configuration.nix
          ./ssh-tunnel.nix
          ./vfio.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                host = "DominusOmnium";
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.gabri = {
                imports = [
                  ./home/home.nix
                ];
              };
            };
          }
          ./hyprland.nix
        ];
      };
    };
}
