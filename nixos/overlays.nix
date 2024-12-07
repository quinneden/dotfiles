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
        {
          blackbox-terminal = prev.blackbox-terminal.overrideAttrs (old: {
            patches = old.patches ++ [
              (pkgs.fetchpatch {
                url = "https://gitlab.gnome.org/raggesilver/blackbox/-/commit/2f45717f1c18f710d9b9fbf21830027c8f0794e7.patch";
                hash = "sha256-VlXttqOTbhD6Rp7ZODgsafOjeY+Lb5sZP277bC9ENXU=";
              })
            ];
          });
        };
    in
    [
      # fontsOverlays
      # miscOverlays
    ];
}
