{
  inputs,
  pkgs,
  lib,
  ...
}: let
  username = "quinn";
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/nautilus.nix
    ../../modules/nixos/system.nix
  ];

  hyprland.enable = true;

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    tmp.cleanOnBoot = true;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

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
        ../../../modules/nixos/home.nix
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
