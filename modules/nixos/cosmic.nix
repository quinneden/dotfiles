{
  nixos-cosmic,
  pkgs,
  ...
}: {
  imports = [nixos-cosmic.nixosModules.default];

  nix.settings = {
    extra-substituters = ["https://cosmic.cachix.org/"];
    extra-trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
  };

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  environment.systemPackages = with pkgs; [
    baobab
    cosmic-applet-emoji-selector
    cosmic-calculator
    cosmic-player
    cosmic-reader
    cosmic-tasks
    drm_info
    firefox
    nautilus
    pavucontrol
    quick-webapps
    swww
    wayshot
    wl-clipboard
  ];

  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
