{
  inputs,
  secrets,
  ...
}:
{
  imports = [
    ./hardware.nix

    ./programs/dconf.nix
    ./programs/gnupg.nix
    ./programs/thunar.nix
    ./services/blueman.nix
    ./services/dbus.nix
    ./services/gnome-keyring.nix
    ./services/greetd.nix
    ./services/gvfs.nix
    ./services/pipewire.nix
    ./virtualisation/containers.nix
    ./virtualisation/docker.nix
    ./virtualisation/podman.nix
    ../modules/nixos/fonts
    ../modules/nixos/bluetooth
    ../modules/nixos/window-managers/hyprland
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
