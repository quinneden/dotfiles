{
  config,
  inputs,
  dotdir,
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
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = ["https://cache.lix.systems"];
      trusted-substituters = config.nix.settings.substituters;
      trusted-public-keys = ["cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="];
      warn-dirty = false;
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
        environment.systemPackages = with pkgs; [
          btrfs-progs
        ];
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
      inherit inputs;
      dotdir = "${config.users.users.quinn.home}/.dotfiles";
    };
    users.quinn = import ./home.nix;
  };
}
