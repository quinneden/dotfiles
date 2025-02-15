{
  pkgs,
  config,
  inputs,
  ...
}:
let
  border-size = config.var.theme.border-size;
  gaps-in = config.var.theme.gaps-in;
  gaps-out = config.var.theme.gaps-out;
  active-opacity = config.var.theme.active-opacity;
  inactive-opacity = config.var.theme.inactive-opacity;
  rounding = config.var.theme.rounding;
  blur = config.var.theme.blur;
  keyboardLayout = config.var.keyboardLayout;
in
{
  imports = [
    ./animations.nix
    ./bindings.nix
    ./polkitagent.nix
    ./uwsm-env.nix
  ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    hyprshot
    hyprpicker
    swappy
    imv
    wf-recorder
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome-themes-extra
    libva
    dconf
    wayland-utils
    wayland-protocols
    glib
    direnv
    meson
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      exec-once = [
        # "${pkgs.bitwarden}/bin/bitwarden"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      monitor = [
        # "HDMI-A-1,2560x1440@144,auto,1"
        ",prefered,auto,1"
      ];

      # env = [
      #   "XDG_CURRENT_DESKTOP,Hyprland"
      #   "XDG_SESSION_TYPE,wayland"
      #   "XDG_SESSION_DESKTOP,Hyprland"
      #   "MOZ_ENABLE_WAYLAND,1"
      #   "ANKI_WAYLAND,1"
      #   "DISABLE_QT5_COMPAT,0"
      #   "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      #   "QT_QPA_PLATFORM=wayland,xcb"
      #   "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      #   "ELECTRON_OZONE_PLATFORM_HINT,auto"
      #   "GTK_THEME,FlatColor:dark"
      #   "GTK2_RC_FILES,/home/hadi/.local/share/themes/FlatColor/gtk-2.0/gtkrc"
      #   "DISABLE_QT5_COMPAT,0"
      #   "DIRENV_LOG_FORMAT,"
      #   "GDK_BACKEND,wayland"
      #   "SDL_VIDEODRIVER,wayland"
      #   "CLUTTER_BACKEND,wayland"
      #   "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
      #   "GSK_RENDERER,ngl"
      # ];

      cursor = {
        no_hardware_cursors = true;
        # default_monitor = "HDMI-A-1";
      };

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        border_part_of_window = true;
        layout = "master";
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled = if blur then "true" else "false";
        };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };

      gestures = {
        workspace_swipe = true;
      };

      misc = {
        # vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      windowrulev2 = [
        "float, tag:modal"
        "pin, tag:modal"
        "center, tag:modal"
      ];

      layerrule = [
        "noanim, launcher"
        "noanim, ^ags-.*"
      ];

      input = {
        kb_layout = keyboardLayout;

        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.1;
        repeat_delay = 250;
        repeat_rate = 40;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          # clickfinger_behavior = true;
        };
      };
    };
  };
  # systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
}
