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
    ([
      miscOverlays
    ])
    ++ (with inputs; [
      nix-shell-scripts.overlays.default
    ]);
}
