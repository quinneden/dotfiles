{pkgs, ...}: let
  cfg = pkgs.writeShellScriptBin "cfg" ''
    find=$(find $dotdir -type f -iregex ".*/$1.nix" | awk '{ print length(), $0 | "sort -n" }' | sed s/"^[0-9][0-9] "/""/g)
    if [[ $1 == -c ]]; then
      edit='codium'
      shift
    else
      edit='mi'
    fi
    if [[ -n $1 ]]; then
      find=$(find $dotdir -type f -iregex ".*/$1.nix" | awk '{ print length(), $0 | "sort -n" }' | sed s/"^[0-9][0-9] "/""/g)
      if [[ -z $find ]]; then
        echo "error: no files matching \"$1\" found in $dotdir"
      else
        if [[ $(echo $find | wc -l) -gt 1 ]]; then
          if [[ $(uname) == 'Linux' && $find =~ nixos ]]; then
            find=$(echo $find | grep -E "nixos|home-manager" | head -n 1)
            $edit $find
          elif [[ $(uname) == 'Darwin' && $find =~ darwin ]]; then
            find=$(echo $find | grep -E "darwin|home-manager" | head -n 1)
            $edit $find
          else
            find=$(echo $find | head -n 1)
            $edit $find
          fi
        else
          $edit $find
        fi
      fi
    else
      $edit $dotdir/flake.nix
    fi
  '';
in {
  home.packages = [cfg];
}
