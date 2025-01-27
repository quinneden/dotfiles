{
  config,
  inputs,
  lib,
  secrets,
  ...
}:
{
  nix = {
    # Pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry =
      let
        flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
      in
      lib.mapAttrs (_: v: { flake = v; }) flakeInputs;

    # Set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      access-tokens = [ "github=${secrets.github.token}" ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
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
      flake-registry = "/etc/nix/registry.json";
      keep-derivations = true;
      keep-outputs = true;
      trusted-users = [
        "root"
        "quinn"
      ];
    };

    gc = {
      automatic = true;
      persistent = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
