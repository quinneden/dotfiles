{
  config,
  inputs,
  dotDir,
  secrets,
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
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs dotDir secrets;
    };
    users.quinn = import ../../../modules/darwin/home.nix;
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix.configureBuildUsers = true;
  ids.uids.nixbld = lib.mkForce 40000;
  ids.gids.nixbld = 30000;

  nix = {
    distributedBuilds = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "${secrets.cachix.quinneden.url}"
      ];
      trusted-public-keys = [
        "${secrets.cachix.quinneden.public-key}"
      ];
      warn-dirty = false;
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      trusted-users = ["quinn" "root"];
      access-tokens = ["github=${secrets.github.api}"];
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 6;
      config = {
        pkgs,
        ...
      }: {
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

  system.stateVersion = 5;
}
