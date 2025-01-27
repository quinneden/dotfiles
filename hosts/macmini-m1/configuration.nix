{
  inputs,
  secrets,
  ...
}:
{
  imports = [
    ./hardware.nix

    ../modules/nixos/bluetooth
    ../modules/nixos/fonts
    ../modules/nixos/nix
    ../modules/nixos/programs
    ../modules/nixos/security
    ../modules/nixos/services
    ../modules/nixos/system
    ../modules/nixos/window-managers/hyprland
    ./programs/dconf.nix
    ./programs/gnupg.nix
    ./programs/thunar.nix
    ./services/blueman.nix
    ./services/dbus.nix
    ./services/gnome-keyring.nix
    ./services/greetd.nix
    ./services/gvfs.nix
    ./virtualisation/containers.nix
    ./virtualisation/podman.nix
  ];

  services = {
    btrfs.autoScrub.enable = true;
    fstrim.enable = true;
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
      ];
    };
  };
}
