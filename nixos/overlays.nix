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
        final: prev:
        {
        };
    in
    [
      miscOverlays
    ];
}
