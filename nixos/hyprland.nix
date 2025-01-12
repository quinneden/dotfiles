{
  pkgs,
  inputs,
  config,
  asztal,
  lib,
  ...
}:
{
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    # services.xserver.displayManager.startx.enable = true;

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        Hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland UWSM";
          binPath = "/etc/profiles/per-user/quinn/bin/Hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };

    security = {
      polkit.enable = true;
      pam.services.ags = { };
    };

    environment.systemPackages = with pkgs; [
      morewaita-icon-theme
      adwaita-icon-theme
      # qogir-icon-theme
      phinger-cursors
      loupe
      nautilus
      baobab
      gnome-text-editor
      gnome-calendar
      gnome-boxes
      gnome-system-monitor
      gnome-control-center
      gnome-weather
      gnome-calculator
      gnome-clocks
      gnome-remote-desktop
      gnome-software # for flatpak
      wl-gammactl
      wl-clipboard
      wayshot
      pavucontrol
      brightnessctl
      swww
    ];

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    services = {
      gvfs.enable = true;
      devmon.enable = true;
      udisks2.enable = true;
      accounts-daemon.enable = true;
      gnome = {
        evolution-data-server.enable = true;
        glib-networking.enable = true;
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
        localsearch.enable = true;
        tinysparql.enable = true;
      };
    };

    services.greetd = {
      enable = true;
      settings.default_session.command = pkgs.writeShellScript "greeter" ''
        export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
        export XCURSOR_THEME=phinger-cursors-dark
        ${asztal}/bin/greeter
      '';
    };

    systemd.tmpfiles.rules = [ "d '/var/cache/greeter' - greeter greeter - -" ];

    system.activationScripts.wallpaper =
      let
        wp = pkgs.writeShellScript "wp" ''
          CACHE="/var/cache/greeter"
          OPTS="$CACHE/options.json"
          HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"

          mkdir -p "$CACHE"
          chown greeter:greeter $CACHE

          if [[ -f "$HOME/.cache/ags/options.json" ]]; then
            cp $HOME/.cache/ags/options.json $OPTS
            chown greeter:greeter $OPTS
          fi

          if [[ -f "$HOME/.config/background" ]]; then
            cp "$HOME/.config/background" $CACHE/background
            chown greeter:greeter "$CACHE/background"
          fi
        '';
      in
      builtins.readFile wp;
  };
}
