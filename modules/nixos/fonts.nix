{
  pkgs,
  inputs,
  ...
}: let
  operator-mono-lig = pkgs.callPackage ./packages/operator-mono-lig.nix {inherit pkgs;};
  operator-mono-nf = pkgs.callPackage ./packages/operator-mono-nf.nix {inherit pkgs;};
in {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      operator-mono-lig
      operator-mono-nf
    ];
  };
}

# fonts = {
#   packages = with pkgs; [
#     source-code-pro
#     noto-fonts
#     noto-fonts-cjk
#     twitter-color-emoji
#     font-awesome
#     powerline-fonts
#     (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
#   ];
#   fontconfig = {
#     hinting.autohint = true;
#   };
# };
