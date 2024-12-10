{
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
{
  nixpkgs.overlays =
    let
      miscOverlays =
        _: prev:
        let
          inherit (prev) system;
        in
        {
          deskflow-darwin = pkgs.deskflow.overrideAttrs ({
            platforms = (prev.platforms ++ [ "aarch64-apple-darwin" ]);
          });
        };
    in
    [
      # miscOverlays
      inputs.lix-module.overlays.default
      inputs.nix-shell-scripts.overlays.default
    ];
}
