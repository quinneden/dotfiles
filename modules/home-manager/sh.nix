{
  pkgs,
  config,
  lib,
  ...
}: let
  aliases = {
    "db" = "distrobox";
    "cddf" = "cd $dotdir";
    "code" = "codium";
    "py" = "python";
    "fuck" = "sudo rm -rf";
    "rf" = "rm -rf";
    "tree" = "eza --icons --tree --group-directories-first -I '.git*'";
    "flake-update" = "sudo nix flake update ~/.dotfiles";

    "gst" = "git status";
    "gb" = "git branch";
    "gch" = "git checkout";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";

    "del" = "gio trash";
  };
in {
  options.shellAliases = with lib;
    mkOption {
      type = types.attrsOf types.str;
      default = {};
    };

  config.programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      shellAliases = aliases // config.shellAliases;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["fzf" "eza" "zoxide"];
      };
      initExtra = ''
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        unsetopt BEEP

        for f (${config.xdg.configHome}/zsh/[^completions]**/*(N.)); do source $f; done

        [[ $(type -w z) =~ 'function' ]] && alias cd='z' || true

        if [[ $TERM_PROGRAM == 'vscode' ]]; then
          autoload -U promptinit; promptinit
          prompt pure
        fi
      '';
      initExtraBeforeCompInit = ''
        fpath+=(${config.xdg.configHome}/zsh/completions)
      '';
      sessionVariables = {
        SHELL = "${pkgs.zsh}/bin/zsh";
        LC_ALL = "en_US.UTF-8";
        dotdir = "/home/quinn/.dotfiles";
        EDITOR = "${pkgs.micro}/bin/micro";
      };
    };

    bash = {
      shellAliases = aliases // config.shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}/bin/bash";
    };
  };
}
