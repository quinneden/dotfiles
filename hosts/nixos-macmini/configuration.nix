{ config, ... }:
{
  imports = [
    ../../nixos/asahi.nix
    ../../nixos/auto-upgrade.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/network-manager.nix
    ../../nixos/nix.nix
    ../../nixos/overlays.nix
    ../../nixos/podman.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/timezone.nix
    ../../nixos/tuigreet.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/variables-config.nix
    ../../nixos/xdg-portal.nix
    ../../nixos/uwsm.nix
    ../../nixos/hyprland.nix

    # Choose your theme here
    ../../themes/stylix/nixy.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "25.05";
}
