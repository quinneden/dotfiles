{
  description = "Configurations of Giddeon";

  outputs = inputs @ {
    self,
    home-manager,
    lix-module,
    nixos-apple-silicon,
    nixpkgs,
    ...
  }: let
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      overlays = ["inputs.nixos-apple-silicon.overlays.default"];
    };
  in {
    packages.aarch64-linux.default =
      nixpkgs.legacyPackages.aarch64-linux.callPackage ./ags {inherit inputs;};

    # nixos config
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          asztal = self.packages.aarch64-linux.default;
        };
        modules = [
          ./nixos/nixos.nix
          lix-module.nixosModules.default
          nixos-apple-silicon.nixosModules.default
          home-manager.nixosModules.home-manager
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

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";

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
