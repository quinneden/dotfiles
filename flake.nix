{
  description = "NixOS and Darwin configurations.";

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
        ] (s: fromJSON (readFile .secrets/${s}.json));

      forEachSystem =
        f:
        inputs.nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
        ] (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      darwinConfigurations = {
        macmini-m4 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs secrets self;
          };
          modules = [
            ./hosts/macmini-m4/configuration.nix
            home-manager.darwinModules.default
            inputs.lix-module.nixosModules.default
            inputs.mac-app-util.darwinModules.default
            inputs.nix-rosetta-builder.darwinModules.default
          ];
        };
      };

      nixosConfigurations = {
        macmini-m1 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs secrets;
          };
          modules = [
            ./hosts/macmini-m1/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.lix-module.nixosModules.default
            inputs.nixos-apple-silicon.nixosModules.default
          ];
        };
      };
    };

  inputs = {
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    hyprland.url = "github:hyprwm/hyprland";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    mac-app-util.url = "github:hraban/mac-app-util";
    micro-autofmt-nix.url = "github:quinneden/micro-autofmt-nix";
    micro-colors-nix.url = "github:quinneden/micro-colors-nix";
    nh.url = "github:viperml/nh";
    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-rosetta-builder = {
      url = "github:quinneden/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:zzywysm/nixos-asahi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
