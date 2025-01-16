{ config, ... }:
{
  virtualisation.podman.enable = true;
  users.users."${config.var.username}".extraGroups = [ "podman" ];
}
