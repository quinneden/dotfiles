{ config, ... }:
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = !config.virtualisation.docker.enable;
      dockerSocket.enable = !config.virtualisation.docker.enable;
    };
  };
}
