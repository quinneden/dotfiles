{
  description = "NixOS & Nix-darwin configurations.";

  outputs = inputs @ {
    home-manager,
    lix-module,
    lix,
    nixos-apple-silicon,
    nixpkgs,
    self,
    ...
  }: let
    pkgs = import inputs.nixpkgs {
      config.allowUnfree = true;
      overlays = [
        nixos-apple-silicon.overlays.default
        lix-module.overlays.default
      ];
    };
  in {
    packages.aarch64-linux.default =
      nixpkgs.legacyPackages.aarch64-linux.callPackage ./ags {inherit inputs;};

    # nixos config
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs pkgs;
          asztal = self.packages.aarch64-linux.default;
        };
        modules = [
          ./nixos/nixos.nix
          lix-module.nixosModules.default
          nixos-apple-silicon.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs pkgs;};
            };
          }
          {networking.hostName = "nixos-macmini";}
        ];
      };
    };

    # macos hm config
    homeConfigurations = {
      "quinn" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ({pkgs, ...}: {
            nix.package = pkgs.nix;
            home.username = "quinn";
            home.homeDirectory = "/Users/quinn";
            imports = [./macos/home.nix];
          })
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        lix.follows = "lix";
      };
    };

    nixos-apple-silicon = {
      url = "github:quinneden/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    matugen.url = "github:InioX/matugen";

    ags.url = "github:Aylur/ags";

    astal.url = "github:astal-sh/libastal";

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };
}
