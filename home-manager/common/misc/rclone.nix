{ config, pkgs, ... }:
{
  home.file."rclone.conf" = {
    source = ../../../.secrets/rclone.conf;
    target = "${config.xdg.configHome}/rclone/rclone.conf";
  };
}
