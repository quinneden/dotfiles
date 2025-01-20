{
  config,
  dotdir,
  inputs,
  secrets,
  ...
}:
{
  imports = [
    ./brew.nix
    ./fonts.nix
    ./modules
    ./overlays.nix
    ./ssh.nix
    ./system.nix
    inputs.home-manager.darwinModules.default
    inputs.mac-app-util.darwinModules.default
    inputs.nix-rosetta-builder.darwinModules.default
  ];

  nix-rosetta-builder = {
    enable = true;
    onDemand = true;
  };

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

  services.nix-daemon.enable = true;

  programs.nh = {
    enable = true;
    flake = toString (config.users.users.quinn.home + "/.dotfiles");
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d";
  };

  nix = {
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
        "http://picache.qeden.me"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="
        "picache.qeden.me:YbzItsTq/D/ns+o9/KzrPraH2hrnmNk/D5aclZZx+YA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      secret-key-files = [ "${../.secrets/keys/cache-private-key.pem}" ];
      warn-dirty = false;
    };

    # linux-builder = {
    #   enable = true;
    #   ephemeral = true;
    #   config =
    #     { pkgs, ... }:
    #     {
    #       nix = {
    #         package = pkgs.lix;
    #         settings = {
    #           max-jobs = 8;
    #           access-tokens = [ "github=${secrets.github.token}" ];
    #           extra-substituters = [
    #             "https://cache.lix.systems"
    #             "https://quinneden.cachix.org"
    #             "http://picache.qeden.me"
    #             "https://nix-community.cachix.org"
    #           ];
    #           extra-trusted-public-keys = [
    #             "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    #             "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="
    #             "picache.qeden.me-1:QMyXTH8r6XY39bR7IF6UtpaxtkjFcIc1bf4N+7DRxvY="
    #             "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #           ];
    #           system-features = [
    #             "benchmark"
    #             "big-parallel"
    #             "nixos-test"
    #             "kvm"
    #           ];
    #         };
    #       };
    #       virtualisation = {
    #         cores = 8;
    #         darwin-builder = {
    #           diskSize = 100 * 1024;
    #           memorySize = 8 * 1024;
    #         };
    #       };
    #     };
    # };
  };

  system.stateVersion = 5;
}
