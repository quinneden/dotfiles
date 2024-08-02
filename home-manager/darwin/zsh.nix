{
  inputs,
  dotdir,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      custom = "/Users/quinn/.scripts/zsh";
      plugins = ["zsh-navigation-tools" "nix-zsh-completions" "direnv" "iterm2"];
    };
    shellAliases = {
      "alx.builds" = "curl -sL https://fedora-asahi-remix.org/builds | EXPERT=1 sh";
      "alx.dev" = "curl -sL https://alx.sh/dev | EXPERT=1 sh";
      "alx.sh" = "curl -sL https://alx.sh | EXPERT=1 sh";
      bs = "stat -f%z";
      cdflake = "cd ${dotdir}";
      cdfl = "cd ${dotdir}";
      cddl = "cd ~/Downloads";
      code = "codium";
      code-flake = "cd ${dotdir} && codium .";
      darwin-switch = "darwin-rebuild switch --flake ${dotdir}#macos";
      df = "df -h";
      du = "du -h";
      flake-tree = "eza -aT ${dotdir} -I '.git*|.vscode*|*.DS_Store|Icon?'";
      fuck = "sudo rm -rf";
      gst = "git status";
      gsur = "git submodule update --init --recursive";
      l = "eza -la --group-directories-first";
      ll = "eza -glAh --octal-permissions --group-directories-first";
      ls = "eza -A";
      lsblk = "diskutil list";
      mi = "micro";
      push = "git push";
      py = "python";
      reboot = "sudo reboot";
      repos = "cd ~/Repositories";
      rf = "rm -rf";
      shutdown = "sudo shutdown -h now";
      sed = "gsed";
      surf = "sudo rm -rf";
      tree = "eza -aT -I '.git*'";
      lsudo = "lima sudo";
    };
    sessionVariables = {
      BAT_THEME = "Dracula";
      dotdir = "${dotdir}";
      EDITOR = "micro";
      EZA_ICON_SPACING = "2";
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:\${INFOPATH:-}";
      LANG = "en_US.UTF-8";
      MICRO_TRUECOLOR = "1";
      PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/run/current-system/sw/bin:/etc/profiles/per-user/quinn/bin\${PATH+:\$PATH}";
      workdir = "$HOME/workdir";
      compdir = "$HOME/.scripts/zsh-custom/completions";
    };
    initExtra = ''
      for f (~/.scripts/zsh/[^plugins]**/*(.)); do source $f; done

      [ -e /opt/homebrew/bin/zoxide ] && alias cd="z"

      iterm2_print_user_vars() {
        iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
      }
    '';
  };
}
