{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;

  commonAliases = {
    cddf = "cd $dotdir";
    cddl = "cd ~/Downloads";
    code = "codium";
    gst = "git status";
    gsur = "git submodule update --init --recursive";
    l = "eza -la --group-directories-first";
    ll = "eza -glAh --octal-permissions --group-directories-first";
    ls = "eza -A";
    push = "git push";
  };

  darwinAliases = {
    "alx.builds" = "curl -sL https://fedora-asahi-remix.org/builds | EXPERT=1 sh";
    "alx.dev" = "curl -sL https://alx.sh/dev | EXPERT=1 sh";
    "alx.sh" = "curl -sL https://alx.sh | EXPERT=1 sh";
    "qeden.systems" = "curl -sL https://qeden.systems/install | sh";
    bs = "stat -f%z";
    "lc" = "limactl";
    reboot = "sudo reboot";
    sed = "gsed";
    shutdown = "sudo shutdown -h now";
    darwin-man = "man configuration.nix";
  };

  linuxAliases = {
    bs = "stat -c%s";
    db = "distrobox";
    tree = "eza -ATL3 --git-ignore";
  };

  darwinVariables = {
    PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/quinn/bin:/Users/quinn/.local/bin:\${PATH:+$PATH}";
    TMPDIR = "/tmp";
    PAGER = "most";
  };

  linuxVariables = {
    NIXOS_CONFIG = "$HOME/.dotfiles";
  };

  initExtraCommon = ''
    if type zoxide &>/dev/null; then eval "$(zoxide init zsh)"; fi

    if type z &>/dev/null; then alias cd='z'; fi

    for f ($HOME/.config/zsh/functions/*(N.)); do source $f; done
  '';

  initExtraDarwin = ''[[ $PATH =~ '/nix/store' ]] || eval $(/opt/homebrew/bin/brew shellenv)'';
in
with lib;
{
  imports = [
    ./programs
  ] ++ (optional isLinux ./pure-prompt.nix);

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    pure-prompt.enable = true;
    shellAliases = commonAliases // (if isDarwin then darwinAliases else linuxAliases);
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.path = "${config.xdg.configHome}/zsh/.zsh_history";

    plugins = with pkgs; [
      {
        name = "zsh-nix-shell";
        src = zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "fzf"
        "eza"
        "zoxide"
        "direnv"
        "${if isDarwin then "iterm2" else ""}"
      ];
      custom = "${config.xdg.configHome}/zsh";
    };

    initExtraBeforeCompInit =
      ''
        fpath+=(
          "${pkgs.lix}/share/zsh/site-functions"
          "/etc/profiles/per-user/quinn/share/zsh/site-functions"
          "${config.xdg.configHome}/zsh/completions"
        )
      ''
      + (optionalString isDarwin ''
        fpath+=(
          "/opt/homebrew/share/zsh/site-functions"
          "/opt/vagrant/embedded/gems/gems/vagrant-2.4.3/contrib/zsh $fpath"
        )
      '');

    initExtra = initExtraCommon + (if pkgs.stdenv.isDarwin then initExtraDarwin else "");

    sessionVariables =
      {
        compdir = "$HOME/.config/zsh/completions";
        dotdir = "$HOME/.dotfiles";
        EDITOR = "mi";
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        MICRO_TRUECOLOR = "1";
      }
      // (if isDarwin then darwinVariables else { })
      // (if isLinux then linuxVariables else { });
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = commonAliases // (if isDarwin then darwinAliases else linuxAliases);
    bashrcExtra = ''
      PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\] \$ "
      HISTCONTROL=ignoredups:erasedups
      shopt -s histappend
      PROMPT_COMMAND='history -a; history -n'
      bind '"\e[A": history-search-backward' # Search history with Up arrow
      bind '"\e[B": history-search-forward'  # Search history with Down arrow
    '';
  };
}
