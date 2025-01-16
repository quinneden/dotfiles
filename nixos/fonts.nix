{ pkgs, inputs, ... }:
{

  fonts = {
    packages =
      (with pkgs; [
        roboto
        work-sans
        comic-neue
        source-sans
        comfortaa
        inter
        lato
        lexend
        jost
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        openmoji-color
        twemoji-color-font
        inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
      ])
      ++ (with pkgs.nerd-fonts; [
        caskaydia-cove
        fira-code
        meslo-lg
      ]);

    enableDefaultPackages = false;

    fontconfig = {
      defaultFonts = {
        monospace = [
          "CaskaydiaCove Nerd Font"
          # "FiraCode Nerd Font Mono"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "SFProDisplay Nerd Font"
          "Noto Color Emoji"
        ];
        serif = [
          "SFProDisplay Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
