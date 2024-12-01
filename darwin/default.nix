{
  config,
  dotdir,
  inputs,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    ./brew.nix
    ./fonts.nix
    ./overlays.nix
    ./system.nix
    inputs.home-manager.darwinModules.default
    inputs.mac-app-util.darwinModules.default
  ];

  users.users.quinn = {
    description = "Quinn Edenfield";
    home = "/Users/quinn";
    shell = "/bin/zsh";
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs dotdir secrets;
    };
    users.quinn = import ./home.nix;
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix = {
    configureBuildUsers = true;
    distributedBuilds = true;
    daemonProcessType = "Adaptive";
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    settings = {
      accept-flake-config = true;
      access-tokens = [ "github=${secrets.github.token}" ];
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      trusted-users = [
        "quinn"
        "root"
      ];
      extra-substituters = [
        "https://cache.lix.systems"
      ];
      extra-trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      warn-dirty = false;
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      config =
        { pkgs, ... }:
        {
          nix = {
            package = pkgs.lix;
            settings = {
              max-jobs = 8;
              access-tokens = [ "github=${secrets.github.token}" ];
              extra-substituters = [
                "https://cache.lix.systems"
              ];
              extra-trusted-public-keys = [
                "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
              ];
            };
          };
          virtualisation = {
            cores = 8;
            darwin-builder = {
              diskSize = 100 * 1024;
              memorySize = 8 * 1024;
            };
          };
        };
    };

    buildMachines = [
      {
        hostName = "fedora-builder";
        maxJobs = 8;
        protocol = "ssh-ng";
        speedFactor = 2;
        system = "aarch64-linux";
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
      }
    ];
  };

  #   programs.ssh.knownHosts = {
  #     "macserver" = {
  #       hostNames = [ "10.0.0.243" ];
  #       publicKeyFile = "/etc/ssh/keys/macserver_ed25519.pub";
  #     };
  #   };

  services.nix-daemon.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--quiet" ];
      upgrade = true;
    };
    global.brewfile = true;
    caskArgs.language = "en-US";
  };

  system.stateVersion = 5;
}
