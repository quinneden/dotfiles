{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
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
          family = "OperatorMono Nerd Font Mono";
          style = "Regular";
        };
        bold.style = "Bold";
        italic.style = "Italic";
        size = 13;
      };

      colors.draw_bold_text_with_bright_colors = true;
      window.opacity = 0.9;

      # imports = [
      #   (pkgs.fetchurl {
      #     url = "https://raw.githubusercontent.com/catppuccin/alacritty/3c808cbb4f9c87be43ba5241bc57373c793d2f17/catppuccin-mocha.yml";
      #     hash = "sha256-28Tvtf8A/rx40J9PKXH6NL3h/OKfn3TQT1K9G8iWCkM=";
      #   })
      # ];
    };
  };
}
