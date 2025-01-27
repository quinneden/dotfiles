{ config, ... }:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    settings = {
      default-key = "8861625C51F5AC8F";
    };
  };
}
