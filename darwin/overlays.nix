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
    ([
      # miscOverlays
    ])
    ++ (with inputs; [
      lix-module.overlays.default
      nix-shell-scripts.overlays.default
      nh.overlays.default
    ]);
}
