{
  pkgs,
  lib,
  config,
  ...
}: {
  options.gnome = {
    enable = lib.mkEnableOption "Gnome";
  };

  config = lib.mkIf config.gnome.enable {
    environment = {
      systemPackages = with pkgs; [
        gnome-extension-manager
        morewaita-icon-theme
        qogir-icon-theme
        wl-clipboard
      ];

      gnome.excludePackages =
        (with pkgs; [
          gedit
          gnome-connections
          gnome-console
          gnome-photos
          gnome-text-editor
          gnome-tour
          snapshot
          cheese # webcam tool
          epiphany # web browser
          evince # document viewer
          geary # email reader
          gnome-font-viewer
          totem # video player
          yelp # Help view
        ])
        ++ (with pkgs.gnome; [
          atomix # puzzle game
          gnome-characters
          gnome-contacts
          gnome-initial-setup
          gnome-maps
          gnome-shell-extensions
          gnome-music
          hitori # sudoku game
          iagno # go game
          tali # poker game
        ]);
    };

    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    programs.dconf.profiles.gdm.databases = [
      {
        settings = {
          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
          };
          "org/gnome/desktop/interface" = {
            cursor-theme = "Qogir";
          };
        };
      }
    ];
  };
}
