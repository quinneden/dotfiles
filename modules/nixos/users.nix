{
  config,
  pkgs,
  ...
}:
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
        "podman"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
