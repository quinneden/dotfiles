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

  programs.nh = {
    enable = true;
    flake = /home/${username}/.dotfiles;
  };

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


  environment.pathsToLink = [
    "/share/zsh"
    "/share/qemu"
    "/share/edk2"
  ];

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
        ../home-manager/ags.nix
        ../home-manager/blackbox.nix
        ../home-manager/browser.nix
        ../home-manager/dconf.nix
        ../home-manager/distrobox.nix
        ../home-manager/git.nix
        ../home-manager/hyprland.nix
        ../home-manager/lf.nix
        ../home-manager/packages.nix
        ../home-manager/zsh.nix
        ../home-manager/theme.nix
        ../home-manager/tmux.nix
        ../home-manager/wezterm.nix
        ../home-manager/micro.nix
        ../home-manager/vscodium
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
