{
  pkgs,
  inputs,
  system,
  ...
}:
{
  nixpkgs.overlays =
    let
      # fontsOverlays = final: prev: {
      #   nerdfonts = prev.nerdfonts.override {
      #     fonts = [
      #       "CaskaydiaCove"
      #       "Hack"
      #       "JetBrainsMono"
      #       "IosevkaTerm"
      #       "Iosevka"
      #       "NerdFontsSymbolsOnly"
      #       "NotoSans"
      #     ];
      #   };
      # };

      miscOverlays = final: prev: {
        # blackbox-terminal = prev.blackbox-terminal.overrideAttrs {
        #   patches = prev.patches ++ [
        #     (pkgs.fetchpatch {
        #       url = "https://gitlab.gnome.org/raggesilver/blackbox/-/commit/2f45717f1c18f710d9b9fbf21830027c8f0794e7.patch";
        #       hash = "sha256-VlXttqOTbhD6Rp7ZODgsafOjeY+Lb5sZP277bC9ENXU=";
        #     })
        #   ];
        # };

        wezterm = inputs.wezterm.packages.${pkgs.system}.default;
      };
    in
    [
      # fontsOverlays
      miscOverlays
    ];
}
