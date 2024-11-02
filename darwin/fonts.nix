{ pkgs, ... }:
let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "CascadiaCode"
      "Hack"
      "JetBrainsMono"
      "IosevkaTerm"
      "Iosevka"
      "NerdFontsSymbolsOnly"
      "Noto"
    ];
  };
in
{
  fonts.packages = [ nerdfonts ];
}
