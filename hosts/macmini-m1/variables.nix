{ config, ... }:
{
  imports = [ ../../nixos/variables-config.nix ];

  config.var = {
    hostname = "nixos-macmini";
    username = "quinn";
    configDirectory = "/home/" + config.var.username + "/.dotfiles";

    keyboardLayout = "us";

    location = "Vancouver";
    timeZone = "America/Los_Angeles";
    defaultLocale = "en_US.UTF-8";

    git = {
      name = "Quinn Edenfield";
      username = "quinneden";
      email = "quinnyxboy@gmail.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = false;

    theme = import ../../themes/var/quinn.nix;
  };
}
