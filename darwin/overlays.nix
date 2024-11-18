{
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
          ks = prev.ks.overrideAttrs (old: {
            version = "4.2.0";
          });
        };
    in
    ([
      miscOverlays
    ])
    ++ (with inputs; [
      lix-module.overlays.lixFromNixpkgs
    ]);
}
