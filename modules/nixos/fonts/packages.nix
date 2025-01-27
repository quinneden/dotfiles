{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      corefonts
      geist-font
      nerd-fonts.geist-mono
      nerd-fonts.caskaydia-cove
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      vistafonts
    ];
  };
}
