function _nix() {
  local ifs_bk="$IFS"
  local input=("${(Q)words[@]}")
  IFS=$'\n'
  local res=($(NIX_GET_COMPLETIONS=$((CURRENT - 1)) "$input[@]"))
  IFS="$ifs_bk"
  local tpe="$res[1]"
  local suggestions=(${res:1})
  if [[ "$tpe" == filenames ]]; then
    compadd -fa suggestions
  else
    compadd -a suggestions
  fi
}

compdef _nix nix
