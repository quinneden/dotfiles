{
  config,
  pkgs,
  ...
}: let
  micro-autofmt-nix = pkgs.callPackage ./micro-autofmt-nix.nix {};
in {
  xdg.configFile."micro/plug/micro-autofmt" = {
    source = micro-autofmt-nix;
    recursive = true;
  };
}
