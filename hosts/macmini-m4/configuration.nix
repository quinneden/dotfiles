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
    extraSpecialArgs = { inherit inputs secrets; };
    users.quinn = {
      programs.home-manager.enable = true;
      home.stateVersion = "25.05";
      imports = [
        inputs.mac-app-util.homeManagerModules.default
        ../../modules/hm/common/files.nix
        ../../modules/hm/common/git.nix
        ../../modules/hm/common/micro
        ../../modules/hm/common/packages.nix
        ../../modules/hm/common/vscodium
        ../../modules/hm/common/zsh
        ../../modules/hm/darwin/packages.nix
        ../../modules/hm/darwin/programs.nix
        ../../modules/hm/darwin/ssh.nix
      ];
    };
  };

  services.nix-daemon.enable = true;

  nix-rosetta-builder = {
    enable = true;
    onDemand = true;
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
      access-tokens = [ ("github=" + secrets.github.token) ];
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
