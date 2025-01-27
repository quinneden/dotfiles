{ config, ... }:
{
  imports = [
    ../../modules/nixos/asahi.nix
    ../../modules/nixos/auto-upgrade.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/overlays.nix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/systemd-boot.nix
    ../../modules/nixos/timezone.nix
    ../../modules/nixos/tuigreet.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/utils.nix
    ../../modules/nixos/variables-config.nix
    ../../modules/nixos/xdg-portal.nix
    ../../modules/nixos/uwsm.nix
    ../../modules/nixos/hyprland.nix

    ../../modules/nixos/themes/stylix/quinn.nix

    ./hardware.nix
    ./variables.nix
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "25.05";
}
