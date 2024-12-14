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
      miscOverlays = final: prev: {
        betterdisplaycli =
          let
            forkpkgs = import inputs.forkpkgs { inherit (pkgs) system; };
          in
          forkpkgs.betterdisplaycli;

        nh = prev.nh.overrideAttrs rec {
          name = prev.name;
          version = "4.0.0-beta.5";
          src = pkgs.fetchGit {
            url = "https://github.com/viperML/nh";
            rev = "refs/tags/${version}";
          };
        };
      };
    in
    ([
      miscOverlays
    ])
    ++ (with inputs; [
      lix-module.overlays.default
      nix-shell-scripts.overlays.default
      nh.overlays.default
    ]);
}
