{ config, pkgs, ... }:
let
  username = config.var.username;
in
{
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users.${username} = {
      isNormalUser = true;
      description = "Quinn Edenfield";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
