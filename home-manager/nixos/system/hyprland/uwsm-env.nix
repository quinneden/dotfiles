{ config, ... }:
{
  home.file.".config/uwsm/env".text = ''
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "MOZ_ENABLE_WAYLAND,1"
    "ANKI_WAYLAND,1"
    "DISABLE_QT5_COMPAT,0"
    "QT_AUTO_SCREEN_SCALE_FACTOR,1"
    "QT_QPA_PLATFORM=wayland,xcb"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "ELECTRON_OZONE_PLATFORM_HINT,auto"
    # "GTK_THEME,FlatColor:dark"
    # "GTK2_RC_FILES,/home/hadi/.local/share/themes/FlatColor/gtk-2.0/gtkrc"
    "DISABLE_QT5_COMPAT,0"
    "DIRENV_LOG_FORMAT,"
    "GDK_BACKEND,wayland"
    "SDL_VIDEODRIVER,wayland"
    "CLUTTER_BACKEND,wayland"
    "GSK_RENDERER,ngl"
  '';
}
# "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
