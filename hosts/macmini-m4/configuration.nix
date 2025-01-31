{
  inputs,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    ../../modules/darwin/brew.nix
    ../../modules/darwin/fonts.nix
    ../../modules/darwin/nh-darwin.nix
    ../../modules/darwin/overlays.nix
    # ../../modules/overlays
    ./system.nix
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
      inherit inputs secrets;
    };
    users.quinn = {
      programs.home-manager.enable = true;
      home.stateVersion = "25.05";
      imports = [
        inputs.mac-app-util.homeManagerModules.default
        ../../modules/home-manager/common/files.nix
        ../../modules/home-manager/common/git.nix
        ../../modules/home-manager/common/micro
        ../../modules/home-manager/common/packages.nix
        ../../modules/home-manager/common/vscodium
        ../../modules/home-manager/common/zsh
        ../../modules/home-manager/darwin/packages.nix
        ../../modules/home-manager/darwin/programs.nix
        ../../modules/home-manager/darwin/ssh.nix
      ];
    };
  };

  services.nix-daemon.enable = true;

  nix-rosetta-builder = {
    enable = true;
    enableRosetta = true;
    debug = true;

    cores = 8;
    memory = "6GiB";
    diskSize = "100GiB";

    onDemand = true;

    config =
      { pkgs, ... }:
      {
        nix = {
          settings = {
            access-tokens = [ "github=${secrets.github.token}" ];
            extra-substituters = [ "https://quinneden.cachix.org" ];
            extra-trusted-public-keys = [
              "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="
            ];
          };
        };
      };
  };

  nix = {
    channel.enable = false;
    configureBuildUsers = true;
    daemonProcessType = "Adaptive";
    distributedBuilds = true;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

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

    settings = {
      accept-flake-config = true;
      access-tokens = [ "github=${secrets.github.token}" ];
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
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

      secret-key-files = [ "${../../.secrets/keys/cache-private-key.pem}" ];

      trusted-users = [
        "quinn"
        "root"
      ];

      warn-dirty = false;
    };
  };

  system.stateVersion = 5;
}
