#!/usr/bin/env bash

garbage_collect() {
  if [[ -e /nix/var/nix/gcroots/auto ]]; then
    sudo rm -rf /nix/var/nix/gcroots/auto
  fi
  sudo nix store gc 2>/dev/null | tail -n 1 | cut -f 1 -d' ' | read str1
  sudo nix-collect-garbage -d 2>/dev/null | tail -n 1 | read str2

  st1="$(echo $str1 | awk -F' ' '{print $1}')"
  st2="$(echo $str1 | awk -F' ' '{print $1}')"
  mib1="$(echo $str1 | awk -F' ' '{print $5}')"
  mib2="$(echo $str1 | awk -F' ' '{print $5}')"

  echo "$((st1+st2)) store paths deleted, $((mib1+mib2)) MiB saved."
}

garbage_collect && exit 0

