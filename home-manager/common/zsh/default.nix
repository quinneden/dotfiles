{
  lib,
  pkgs,
  config,
  ...
}:
let
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
{
  imports = [ ./pure-prompt.nix ];

  programs.pure-prompt.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    shellAliases = commonAliases // (if pkgs.stdenv.isDarwin then darwinAliases else linuxAliases);
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.path = "${config.xdg.configHome}/zsh/.zsh_history";

    oh-my-zsh = {
      enable = true;
      plugins = [
        "fzf"
        "eza"
        "zoxide"
        "direnv"
        "${if pkgs.stdenv.isDarwin then "iterm2" else ""}"
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
      + (if pkgs.stdenv.isDarwin then ''fpath+=("/opt/homebrew/share/zsh/site-functions")'' else '''');

    initExtra = initExtraCommon + (if pkgs.stdenv.isDarwin then initExtraDarwin else "");

    sessionVariables =
      {
        compdir = "$HOME/.config/zsh/completions";
        dotdir = "$HOME/.dotfiles";
        EDITOR = "mi";
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        MICRO_TRUECOLOR = "1";
        PAGER = "bat --style=grid,numbers --wrap=never";
      }
      // (if pkgs.stdenv.isDarwin then darwinVariables else { })
      // (if pkgs.stdenv.isLinux then linuxVariables else { });
  };
}
