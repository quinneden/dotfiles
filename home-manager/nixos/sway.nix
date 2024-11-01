let
  mod = "Mod4";
# alt = "Mod1";
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      input = {
        "*" = {
          xkb_layout = "us";
          natural_scroll = "enabled";
        };
      };
      bars = [ ];
      keybindings = {
        "${mod}+Return" = "exec xterm";
        "${mod}+w" = "exec firefox";
        "${mod}+q" = "kill";
        "${mod}+f" = "floating toggle";
      };
      floating = {
        modifier = mod;
      };
      focus = {
        followMouse = true;
      };
    };
  };
}
