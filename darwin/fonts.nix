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
  # fonts.packages = [ nerdfonts ];
  fonts.packages = with pkgs.nerd-fonts; [
    caskaydia-cove
    hack
    fira-code
    jetbrains-mono
    iosevka
    iosevka-term
    symbols-only
    noto
  ];
}
