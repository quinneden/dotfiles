let
  mod = "Mod4";
in
# alt = "Mod1";
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
