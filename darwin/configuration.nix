{
  config,
  inputs,
  dotDir,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./brew.nix
    ./system.nix
  ];

  users.users.quinn = {
    description = "Quinn Edenfield";
    home = "/Users/quinn";
    shell = pkgs.zsh;
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
        "https://cache.lix.systems"
      ];
      trusted-substituters = config.nix.settings.substituters;
      trusted-public-keys = [
        "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs dotDir;
    };
    users.quinn = import ./home.nix;
  };
}
