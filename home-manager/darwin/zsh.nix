{
  dotDir,
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    oh-my-zsh = {
      enable = true;
      custom = "${config.xdg.configHome}/zsh";
      plugins = ["zsh-navigation-tools" "nix-zsh-completions" "direnv" "iterm2"];
    };
    shellAliases = {
      "alx.builds" = "curl -sL https://fedora-asahi-remix.org/builds | EXPERT=1 sh";
      "alx.dev" = "curl -sL https://alx.sh/dev | EXPERT=1 sh";
      "alx.sh" = "curl -sL https://alx.sh | EXPERT=1 sh";
      bs = "stat -f%z";
      cddl = "cd ~/Downloads";
      cddf = "cd ${dotDir}";
      code = "codium";
      code-flake = "cd ${dotDir} && codium .";
      darwin-switch = "darwin-rebuild switch --flake ${dotDir}#macos";
      df = "df -h";
      du = "du -h";
      flake-tree = "eza -aT ${dotDir} -I '.git*|.vscode*|*.DS_Store|Icon?'";
      fuck = "sudo rm -rf";
      gst = "git status";
      gsur = "git submodule update --init --recursive";
      l = "eza -la --group-directories-first";
      ll = "eza -glAh --octal-permissions --group-directories-first";
      ls = "eza -A";
      lsblk = "diskutil list";
      lsudo = "lima sudo";
      mi = "micro";
      push = "git push";
      py = "python";
      reboot = "sudo reboot";
      rf = "rm -rf";
      sed = "gsed";
      shutdown = "sudo shutdown -h now";
      surf = "sudo rm -rf";
      tree = "eza -aT -I '.git*'";
    };
    sessionVariables = {
      BAT_THEME = "Dracula";
      compdir = "${config.xdg.configHome}/zsh/completions";
      dotdir = "${dotDir}";
      EDITOR = "micro";
      EZA_ICON_SPACING = "2";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_REPOSITORY = "/opt/homebrew";

      INFOPATH = "/opt/homebrew/share/info:\${INFOPATH:-}";
      LANG = "en_US.UTF-8";
      MICRO_TRUECOLOR = "1";
      PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/make/libexec/gnubin:/run/current-system/sw/bin:/etc/profiles/per-user/quinn/bin:/usr/local/bin:/Users/quinn/.local/bin\${PATH+:\$PATH}";
      workdir = "$HOME/workdir";
    };
    initExtra = ''
      for f (~/.config/zsh/completions/*(N.)); do
        source $f
        base=$(basename $f)
        cmd=$(basename $f | tr -d '_')
        if [[ ! $(type -w $cmd) =~ 'none' ]]; then
          compdef $base $cmd
        fi
      done

      for f (~/.config/zsh/functions/*(N.)); do source $f; done

      [ -e /opt/homebrew/bin/zoxide ] && alias cd="z"
    '';
  };
}
