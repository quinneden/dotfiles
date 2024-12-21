{
  description = "NixOS & Nix-darwin configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    forkpkgs.url = "github:quinneden/nixpkgs";
    hyprland.url = "github:hyprwm/hyprland";
    hyprcursor-phinger.url = "github:quinneden/hyprcursor-phinger";
    matugen.url = "github:InioX/matugen/3a5e27b2eb0593d2a3e86fd76aefb79e647086a2";
    ags.url = "github:aylur/ags/v1";
    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    mac-app-util.url = "github:hraban/mac-app-util";
    micro-autofmt-nix.url = "github:quinneden/micro-autofmt-nix";
    micro-colors-nix.url = "github:quinneden/micro-colors-nix";
    wezterm.url = "github:wez/wezterm?dir=nix";
    nh.url = "github:viperml/nh";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
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

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      home-manager,
      nix-darwin,
      nixpkgs,
      self,
      ...
    }:
    let
      secrets =
        let
          inherit (builtins) fromJSON readFile;
          inherit (nixpkgs) lib;
        in
        lib.genAttrs [
          "cachix"
          "cloudflare"
          "github"
          "pubkeys"
        ] (secretFile: fromJSON (readFile .secrets/${secretFile}.json));

      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
      ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      packages.aarch64-linux.default = nixpkgs.legacyPackages.aarch64-linux.callPackage ./nixos/ags {
        inherit inputs;
      };

      packages.aarch64-darwin = {
        tabby-release = nixpkgs.legacyPackages.aarch64-darwin.callPackage ./drv/tabby-release.nix { };
      };

      darwinConfigurations = {
        macos = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs secrets self;
            dotdir = "$HOME/.dotfiles";
          };
          modules = [ ./darwin ];
        };
      };

      nixosConfigurations = {
        nixos-macmini = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs secrets;
            asztal = self.packages.aarch64-linux.default;
          };
          modules = [
            ./nixos
            home-manager.nixosModules.home-manager
            inputs.lix-module.nixosModules.default
            inputs.nixos-apple-silicon.nixosModules.default
          ];
        };
      };
    };
}
