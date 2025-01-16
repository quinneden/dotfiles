{
  config,
  inputs,
  secrets,
  ...
}:
let
  autoGarbageCollector = config.var.autoGarbageCollector;
in
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    channel.enable = false;
    extraOptions = ''
      warn-dirty = false
    '';
    settings = {
      access-tokens = [ "github=${secrets.github.token}" ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://hyprland.cachix.org"
        "https://cache.lix.systems"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      trusted-users = [ "quinn" ];
    };
    gc = {
      automatic = autoGarbageCollector;
      persistent = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
