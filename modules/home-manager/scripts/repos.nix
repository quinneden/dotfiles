{pkgs, ...}: let
  repos = pkgs.writeShellScriptBin "repos" ''
    main() {
      if [[ $1 == '-d' ]]; then
        cmd="trash"
        shift
      else
        cmd="cd"
      fi
      if [[ $# -ge 1 ]]; then
        if [[ $1 =~ 'personal' || $1 =~ 'hack-ons' ]]; then
          subdir=""
        else
          subdir="personal/"
        fi
        subdir+="$1"
        eval $cmd "$HOME"/repos/"$subdir"
      else
        eval $cmd "$HOME"/repos
      fi
    }

    main "$@" || exit 1
  '';
in {
  home.packages = [repos];

  xdg.configFile."zsh/completions/_repos".text = ''
    _repos() {
      _files -/ -W $HOME/repos/personal || _files -/ -W $HOME/repos/
    }
  '';
}
