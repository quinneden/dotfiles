{ pkgs, ... }:
{
  users.users.quinn = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "input"
      "network"
      "networkmanager"
      "plugdev"
      "libvirtd"
      "mysql"
      "docker"
      "podman"
      "git"
    ];
  };

  programs.zsh.enable = true;
}
