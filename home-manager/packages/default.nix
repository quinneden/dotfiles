{config, pkgs, ...}: let
  micro-autofmt-nix = pkgs.callPackage ./micro-autofmt-nix.nix {};
in {
  home.packages = [
    micro-autofmt-nix
  ];
}
