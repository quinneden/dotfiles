{
  inputs,
  lib,
  secrets,
  pkgs,
  ...
}:
let
  username = "quinn";
in
{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./audio.nix
    ./locale.nix
    ./nautilus.nix
    ./hyprland.nix
    ./gnome.nix
    ./overlays.nix
  ];

  hyprland.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = username;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "podman"
      "i2c-dev"
    ];
  };

  # programs.nh = {
  #   enable = true;
  #   flake = /home/${username}/.dotfiles;
  # };

  programs.direnv = {
    enable = true;
    silent = false;
    enableZshIntegration = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  programs.zsh.enable = true;

  environment.pathsToLink = [
    "/share/zsh"
    "/share/qemu"
    "/share/edk2"
    "share/deskflow"
  ];

  environment.sessionVariables = {
    GSK_RENDERER = "ngl";
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs secrets;
    };
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ./home.nix
      ];
    };
  };

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = [ "Gnome" ];
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
    };
  };
}
