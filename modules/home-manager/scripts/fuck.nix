{pkgs, ...}: let
  fuck = pkgs.writeShellScriptBin "fuck" ''
    main() {
      if [[ $(uname) == "Linux" ]]; then
        local trash_cmd="${pkgs.gtrash}/bin/gtrash put"
        local trash_empty_cmd="${pkgs.gtrash}/bin/gtrash rm -f"
      else
        local trash_cmd="trash"
        local trash_empty_cmd="trash -ey"
      fi

      local files=()
      local PROTECT=($HOME/.dotfiles $HOME/workdir $HOME/repos $HOME/.config)

      if [[ $1 == '-f' ]]; then
        shift; local EMPTY_NOW=1
      fi

      for f in "''${@}"; do
        if [[ -L $f ]]; then
          files+=("$PWD/$f")
        elif [[ -e $f ]]; then
          files+=("$(realpath $f)")
        else
          echo "error: path does not exist"
          return 1
        fi
      done

      for i in "''${PROTECT[@]}"; do
        for f in "''${files[@]}"; do
          if [[ $f == $i ]]; then
            echo "error: cannot delete protected file or directory: $f"
            return 1
          fi
        done
      done

      [[ -n "''${files}" ]] && $trash_cmd "''${files[@]}"

      if [[ $? -eq 0 ]]; then
        local LIST_DEL=$(for f in "''${files[@]}"; do printf "  $(basename $f)\n"; done)
        printf "Deleted:\n$LIST_DEL\n"
      fi

      if [[ $EMPTY_NOW -eq 1 ]]; then
        $trash_empty_cmd "''${files[@]}" &>/dev/null
      else
        ((sleep 60 && $trash_empty_cmd "''${files[@]}" &>/dev/null) &)
      fi
    }

    main "''${@}" && exit
  '';
in {home.packages = [fuck];}
