{
  description = "NixOS & Nix-darwin configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    forkpkgs.url = "git+file:///Users/quinn/repos/forks/nixpkgs";
    hyprland.url = "github:hyprwm/hyprland";
    hyprcursor-phinger.url = "github:quinneden/hyprcursor-phinger";
    matugen.url = "github:InioX/matugen";
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

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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
      # secrets = {
      #   cachix = builtins.fromJSON (builtins.readFile .secrets/cachix.json);
      #   cloudflare = builtins.fromJSON (builtins.readFile .secrets/cloudflare.json);
      #   github = builtins.fromJSON (builtins.readFile .secrets/github.json);
      #   pubkeys = builtins.fromJSON (builtins.readFile .secrets/pubkeys.json);
      # };

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

      darwinConfigurations = {
        macos = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs secrets;
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
