{
  pkgs,
  config,
  lib,
  ...
}: let
  aliases = {
    "db" = "distrobox";
    "mi" = "micro";
    "code" = "codium";
    "py" = "python";
    "fuck" = "sudo rm -rf";
    "rf" = "rm -rf";
    "tree" = "eza --icons --tree --group-directories-first -I '.git*'";
    "nix-switch" = "sudo nixos-rebuild switch --flake ~/.dotfiles#nixos --impure";
    "flake-update" = "sudo nix flake update ~/.dotfiles";
    "nix-clean" = "sudo nix-collect-garbage -d && sudo rm /nix/var/nix/gcroots/auto/* && nix-collect-garbage -d";

    "gs" = "git status";
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
      shellAliases = aliases // config.shellAliases;
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["fzf" "eza" "zsh-navigation-tools"];
      };
      initExtra = ''
        SHELL=${pkgs.zsh}/bin/zsh
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        unsetopt BEEP
        for f (${config.xdg.configHome}/zsh/**/*(N.)); do source $f; done
      '';
      sessionVariables = {
        SHELL = "${pkgs.zsh}/bin/zsh";
        LC_ALL = "en_US.UTF-8";
        dotdir = "/home/quinn/.dotfiles";
        EDITOR = "micro";
      };
    };

    bash = {
      shellAliases = aliases // config.shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
    };
  };
}
