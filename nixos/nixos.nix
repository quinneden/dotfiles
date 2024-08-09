{
  inputs,
  pkgs,
  lib,
  ...
}: let
  username = "quinn";
in {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./gnome.nix
    ./hardware.nix
    ./hyprland.nix
    ./locale.nix
    ./nautilus.nix
    ./system.nix
  ];

  hyprland.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = username;
    shell = "${pkgs.zsh}/bin/zsh";
    extraGroups = [
      "nixosvmtest"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "docker"
    ];
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ./home.nix
      ];
    };
  };

  environment.pathsToLink = [
    "/share/zsh"
    "/share/qemu"
    "/share/edk2"
  ];

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = ["Gnome"];
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
    };
  };
}
