{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../colors.nix
  ];

  colors.palette = "oxocarbon-dark";

  stylix = {
    enable = true;

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.caskaydia-cove;
        name = "CaskaydiaCove Nerd Font Mono";
      };
      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 13;
        terminal = 13;
      };
    };

    polarity = "dark";

    image = pkgs.fetchurl {
      url =
        "https://github.com/anotherhadi/nixy-wallpapers/blob/main/wallpapers/" + "3.png" + "?raw=true";
      sha256 = "sha256-fT2ah18IAxoy3hzlLl9SkqhchzfVvZneUrZWzntMo40=";
    };

  };

}
