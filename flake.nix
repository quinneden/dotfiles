{
  description = "NixOS & Nix-darwin configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    forkpkgs.url = "github:quinneden/nixpkgs";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:zzywysm/nixos-asahi";
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
      url = "github:quinneden/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    ags.url = "github:aylur/ags/v1";
    hyprcursor-phinger.url = "github:quinneden/hyprcursor-phinger";
    hyprland.url = "github:hyprwm/hyprland";
    mac-app-util.url = "github:hraban/mac-app-util";
    matugen.url = "github:InioX/matugen/3a5e27b2eb0593d2a3e86fd76aefb79e647086a2";
    micro-autofmt-nix.url = "github:quinneden/micro-autofmt-nix";
    micro-colors-nix.url = "github:quinneden/micro-colors-nix";
    nh.url = "github:viperml/nh";
    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    sops-nix.url = "github:Mic92/sops-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    stylix.url = "github:danth/stylix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    # zen-browser.url = "git+https://git.sr.ht/~canasta/zen-browser-flake/";
    nixy-wallpapers = {
      url = "github:anotherhadi/nixy-wallpapers";
      flake = false;
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
        ] (s: fromJSON (readFile .secrets/${s}.json));

      forEachSystem = inputs.nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
      ];
    in
    {
      formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

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
          };
          modules = [
            ./hosts/nixos-macmini/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.lix-module.nixosModules.lixFromNixpkgs
            inputs.nixos-apple-silicon.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };
      };

      apps = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs) lib writeShellApplication;

          deploySystem = writeShellApplication {
            name = "deploy-dotfiles";
            runtimeInputs = with pkgs; [ nixos-rebuild ];
            text = ''
              # get_arg() {
              #   echo "''${2:-''${1#*=}}"
              # }

              # while [[ $# -gt 0 ]]; do
              #   case "$1" in
              #     -i | --install)
              #       FIRST_BUILD=true
              #       shift
              #       ;;
              #     boot | switch)
              #       subcommand="$1"
              #       shift
              #       ;;
              #     *)
              #       target="$1"
              #       shift
              #       ;;
              #   esac
              # done

              # FIRST_BUILD="''${FIRST_BUILD:-false}"
              # subcommand="''${subcommand:-switch}"
              # target="''${target:-nixos-macmini}"

              # if [[ $FIRST_BUILD == true ]]; then
              #   nixos-install --show-trace \
              #     --target-host "root@$target" \
              #     --flake .
              # else
                nixos-rebuild boot --fast --show-trace \
                  --target-host "root@nixos-macmini" \
                  --flake .#nixos-macmini
              # fi
            '';
          };
        in
        rec {
          default = deploy;

          deploy = {
            type = "app";
            program = lib.getExe deploySystem;
          };
        }
      );
    };
}
