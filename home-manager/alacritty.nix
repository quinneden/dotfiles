{pkgs, ...}: let
  aura-theme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/daltonmenezes/aura-theme/main/packages/alacritty/aura-theme.toml";
    hash = "sha256-CXu5F7B1baj4a4OXDDQEz0+DRKHrT689Si9W+iU077E=";
  };
in {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [aura-theme];

      shell = "${pkgs.tmux}/bin/tmux";
      # shell = "${pkgs.zsh}/bin/zsh";
      window = {
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        startup_mode = "Maximized";
      };

      mouse.hide_when_typing = true;

      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };

      scrolling.history = 10000;

      font = {
        normal = {
          family = "Operator Mono Lig Book";
          style = "Book";
        };
        italic.style = "Italic";
        bold.style = "OperatorMono Nerd Font Mono Bold";
        size = 13;
      };

      colors.draw_bold_text_with_bright_colors = true;
      window.opacity = 0.9;
    };
  };
}
