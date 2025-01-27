{
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland-hm = {
        prettyName = "Hyprland (HM)";
        comment = "hyprland from home-manager";
        binPath = "/etc/profiles/per-user/quinn/bin/Hyprland";
      };
    };
  };
}
