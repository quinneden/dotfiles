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
    };

    bash = {
      shellAliases = aliases // config.shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
    };

    nushell = {
      shellAliases = aliases // config.shellAliases;
      enable = false;
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "\"  \"";
        PROMPT_INDICATOR_VI_NORMAL = "\"∙ \"";
        PROMPT_COMMAND = ''""'';
        PROMPT_COMMAND_RIGHT = ''""'';
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = ''"${pkgs.nushell}/bin/nu"'';
        EDITOR = config.home.sessionVariables.EDITOR;
        VISUAL = config.home.sessionVariables.VISUAL;
      };
      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "emacs";

          ls.clickable_links = true;
          rm.always_trash = true;

          table = {
            mode = "compact"; # compact thin rounded
            index_mode = "always"; # alway never auto
            header_on_separator = false;
          };

          cursor_shape = {
            vi_insert = "line";
            vi_normal = "block";
          };

          menus = [
            {
              name = "completion_menu";
              only_buffer_difference = false;
              marker = "? ";
              type = {
                layout = "columnar"; # list, description
                columns = 4;
                col_padding = 2;
              };
              style = {
                text = "magenta";
                selected_text = "blue_reverse";
                description_text = "yellow";
              };
            }
          ];
        };
        completions = let
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
        in
          names:
            builtins.foldl'
            (prev: str: "${prev}\n${str}") ""
            (map (name: completion name) names);
      in ''
        $env.config = ${conf};
        ${completions ["cargo" "git" "nix" "npm" "poetry" "curl"]}

        alias pueue = ${pkgs.pueue}/bin/pueue
        alias pueued = ${pkgs.pueue}/bin/pueued
        use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu
      '';
    };
  };
}
