{
  description = "NixOS & Nix-darwin configurations.";

  outputs = inputs @ {
    devenv,
    home-manager,
    lix-module,
    nix-darwin,
    nixos-apple-silicon,
    nixpkgs,
    self,
    ...
  }: let
    dotDir = "$HOME/.dotfiles";
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ] (system:
        function (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }));
  in {
    packages = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${self.system}.callPackage ./ags {inherit inputs;};
    });

    nixosConfigurations = {
      "nixos-macmini" = nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
          overlays = [
            nixos-apple-silicon.overlays.default
          ];
        };
        specialArgs = {
          inherit inputs dotDir;
          asztal = self.packages.${self.system}.default;
        };
        modules = [
          ./hosts/macmini/nixos
          lix-module.nixosModules.default
          nixos-apple-silicon.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs dotDir;};
            };
          }
          {networking.hostName = "nixos-macmini";}
        ];
      };

      "relic" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs dotDir;
          asztal = self.packages.${self.system}.default;
        };
        modules = [
          ./hosts/relic
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs dotDir;};
            };
          }
          {networking.hostName = "nixos-relic";}
        ];
      };
    };

    # darwin config
    darwinConfigurations = {
      "macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs dotDir;};
        modules = [
          ./hosts/macmini/darwin
          home-manager.darwinModules.default
          {networking.hostName = "macos-macmini";}
        ];
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://quinneden.cachix.org";
    extra-trusted-public-keys = "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA=";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:quinneden/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv";

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

    flake-parts.url = "github:hercules-ci/flake-parts";

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };
}
