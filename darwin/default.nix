{
  config,
  dotdir,
  inputs,
  lib,
  pkgs,
  secrets,
  ...
}:
# let
#   push-to-picache = pkgs.writeShellScriptBin ''
#     set -eu
#     set -f
#     export IFS=' '
#     echo "Uploading paths" $OUT_PATHS
#     exec nix copy --to "http://picache.qeden.me" $OUT_PATHS
#   '';
# in
{
  imports = [
    # ./aerospace.nix
    ./brew.nix
    ./fonts.nix
    ./modules
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
    # gc = {
    #   user = "root";
    #   automatic = true;
    #   options = "--delete-older-than 3d";
    #   interval = [
    #     {
    #       Hour = 4;
    #       Minute = 15;
    #       Weekday = 7;
    #     }
    #   ];
    # };

    optimise = {
      user = "root";
      automatic = true;
      interval = [
        {
          Hour = 4;
          Minute = 15;
          Weekday = 7;
        }
      ];
    };

    channel.enable = false;

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
      trusted-users = [
        "quinn"
        "root"
      ];
      extra-substituters = [
        "https://cache.lix.systems"
        "https://quinneden.cachix.org"
        # "http://picache.qeden.me"
      ];
      extra-trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="
        # "picache.qeden.me:YbzItsTq/D/ns+o9/KzrPraH2hrnmNk/D5aclZZx+YA="
      ];
      # secret-key-files = [ ../.secrets/keys/cache-secret-key.pem ];
      warn-dirty = false;
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      config =
        { pkgs, ... }:
        {
          imports = [
            (
              let
                module = fetchTarball {
                  name = "source";
                  url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
                  sha256 = "sha256-DN5/166jhiiAW0Uw6nueXaGTueVxhfZISAkoxasmz/g=";
                };
                lixSrc = fetchTarball {
                  name = "source";
                  url = "https://git.lix.systems/lix-project/lix/archive/2.91.1.tar.gz";
                  sha256 = "sha256-hiGtfzxFkDc9TSYsb96Whg0vnqBVV7CUxyscZNhed0U=";
                };
              in
              import "${module}/module.nix" { lix = lixSrc; }
            )
          ];
          nix = {
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

    # buildMachines = [
    #   {
    #     hostName = "fedora-builder";
    #     maxJobs = 8;
    #     protocol = "ssh-ng";
    #     speedFactor = 2;
    #     system = "aarch64-linux";
    #     supportedFeatures = [
    #       "nixos-test"
    #       "benchmark"
    #       "big-parallel"
    #       "kvm"
    #     ];
    #   }
    # ];
  };

  services.nix-daemon.enable = true;

  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${pkgs.system}.default;
    flake = config.users.users.quinn.home;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1d";
  };

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
