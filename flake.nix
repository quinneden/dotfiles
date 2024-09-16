{
  description = "NixOS & Nix-darwin configurations.";

  outputs = inputs @ {
    home-manager,
    lix-module,
    nix-darwin,
    nixos-apple-silicon,
    nixpkgs,
    self,
    ...
  }: let
    secrets = with inputs; builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    dotDir = "$HOME/.dotfiles";
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ] (system: pkgs:
        function (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }));
  in {
    packages = forAllSystems (pkgs: {
      ags = pkgs.callPackage ./ags {inherit inputs;};
    });

    darwinConfigurations = let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixos-apple-silicon.overlays.default
          lix-module.overlays.lixFromNixpkgs
        ];
      };
    in {
      "macos" = nix-darwin.lib.darwinSystem {
        inherit system pkgs;
        specialArgs = {inherit inputs dotDir secrets;};
        modules = [
          ./hosts/macmini/darwin
          lix-module.nixosModules.lixFromNixpkgs
          home-manager.darwinModules.default
          {networking.hostName = "macos-macmini";}
        ];
      };
    };

    nixosConfigurations = {
      "nixos-macmini" = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            nixos-apple-silicon.overlays.default
            (final: prev: {neovim = inputs.nixvim.packages.${system}.default;})
          ];
        };
        specialArgs = {
          inherit inputs dotDir secrets;
          asztal = self.packages.${self.system}.ags;
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
              extraSpecialArgs = {inherit inputs dotDir secrets;};
              backupFileExtension = "backup";
            };
          }
          {networking.hostName = "nixos-macmini";}
        ];
      };

      "relic" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs dotDir;
          asztal = self.packages.${self.system}.ags;
        };
        modules = [
          ./hosts/relic
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs dotDir secrets;};
              backupFileExtension = "backup";
            };
          }
          {networking.hostName = "nixos-relic";}
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:elythh/nixvim";
    devenv.url = "github:cachix/devenv";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    matugen.url = "github:InioX/matugen";
    ags.url = "github:Aylur/ags";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
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
    # hyprland-hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };
}
