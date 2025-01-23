{ config, ... }:
{
  home.file = {
    ".hushlogin".text = "";

    "rclone.conf" = {
      source = ../../../.secrets/rclone.conf;
      target = "${config.xdg.configHome}/rclone/rclone.conf";
    };
  };
}
