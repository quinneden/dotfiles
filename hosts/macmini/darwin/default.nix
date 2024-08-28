{
  config,
  inputs,
  dotDir,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../modules/darwin/brew.nix
    ../../../modules/darwin/system.nix
  ];

  users.users.quinn = {
    description = "Quinn Edenfield";
    home = "/Users/quinn";
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs dotDir;
    };
    users.quinn = import ../../../modules/darwin/home.nix;
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix.configureBuildUsers = true;
  ids.uids.nixbld = lib.mkForce 40000;

  nix = {
    package = pkgs.lix;
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://quinneden.cachix.org"
      ];
      trusted-substituters = config.nix.settings.substituters;
      trusted-public-keys = [
        "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="
      ];
      warn-dirty = false;
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      trusted-users = ["quinn" "root"];
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 6;
      config = {pkgs, ...}: {
        virtualisation = {
          cores = 6;
          darwin-builder = {
            diskSize = 100 * 1024;
            memorySize = 6 * 1024;
          };
        };
      };
    };
  };

  services = {
    activate-system.enable = true;
    nix-daemon.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = ["--quiet"];
      upgrade = true;
    };
    global.brewfile = true;
    caskArgs.language = "en-US";
  };
}
