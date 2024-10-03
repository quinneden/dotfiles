{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  username = "quinn";
in {
  imports = [
    ./hardware.nix
    ../../../modules/nixos/audio.nix
    ../../../modules/nixos/fonts.nix
    ../../../modules/nixos/gnome.nix
    ../../../modules/nixos/hyprland.nix
    ../../../modules/nixos/locale.nix
    ../../../modules/nixos/nautilus.nix
    ../../../modules/nixos/system.nix
  ];

  hyprland.enable = true;

  boot = {
    binfmt.emulatedSystems = ["x86_64-linux"];
    tmp.cleanOnBoot = true;
    m1n1CustomLogo = ../../../assets/bootlogo-m1n1.png;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };

  hardware.asahi = {
    withRust = true;
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    peripheralFirmwareDirectory = builtins.fetchTarball {
      url = "";
      sha256 = "";
    };
  };
  # hardware.graphics = {
    # enable = true;
    # package = lib.mkDefault config.hardware.asahi.pkgs.mesa-asahi-edge.drivers;
  # };

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

  environment.systemPackages = with pkgs; [asahi-bless];

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = ["Gnome"];
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
    };
  };
}
