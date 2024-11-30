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
          ks = prev.ks.overrideAttrs (
            finalAttrs: previousAttrs: {
              version = "0.4.2";
              src = prev.fetchFromGitHub {
                owner = "loteoo";
                repo = "ks";
                rev = "${finalAttrs.version}";
                hash = "sha256-v05wqlG7Utq1b7ctvDY9MCdjHVVZZNNzuHaIBwuRjEE=";
              };
            }
          );
        };
    in
    ([
      miscOverlays
    ])
    ++ (with inputs; [
      lix-module.overlays.lixFromNixpkgs
    ]);
}
