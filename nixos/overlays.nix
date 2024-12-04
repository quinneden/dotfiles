{
  pkgs,
  inputs,
  system,
  ...
}:
{
  nixpkgs.overlays =
    let
      fontsOverlays = _: prev: {
        nerdfonts = prev.nerdfonts.override {
          fonts = [
            "CaskaydiaCove"
            "Hack"
            "JetBrainsMono"
            "IosevkaTerm"
            "Iosevka"
            "NerdFontsSymbolsOnly"
            "NotoSans"
          ];
        };
      };

      miscOverlays =
        _: prev:
        let
          inherit (prev) system;
        in
        { };
    in
    [
      # fontsOverlays
      # miscOverlays
    ];
}
