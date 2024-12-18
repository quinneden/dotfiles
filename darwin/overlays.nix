{
  lib,
  pkgs,
  self,
  inputs,
  ...
}:
let
  flakeOverlays = with inputs; [
    lix-module.overlays.default
    nh.overlays.default
    nix-shell-scripts.overlays.default
    nur.overlays.default
  ];

  packageOverlays = final: prev: {
    betterdisplaycli =
      let
        forkpkgs = import inputs.forkpkgs { inherit (pkgs) system; };
      in
      forkpkgs.betterdisplaycli;

    nh = prev.nh.overrideAttrs rec {
      version = "4.0.0-beta.5";
      src = pkgs.fetchFromGitHub {
        owner = "viperML";
        repo = "nh";
        tag = "v${version}";
        hash = "sha256-B3PK+e717FdrQXhg53DwTPWLY458yGYsH20tYj0pgzU=";
      };
    };
    tabby-release = self.packages.aarch64-darwin.tabby-release;
  };
in
{
  nixpkgs.overlays = flakeOverlays ++ [
    packageOverlays
  ];
}
