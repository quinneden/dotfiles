{pkgs, ...}: let
  nix-clean = pkgs.writeShellScriptBin "nix-clean" ''
    printf "Collecting garbage from nix store..."
    (sudo -E nix store gc 2>/dev/null | tail -n 1) | read -r str1
    (sudo -E nix-collect-garbage -d 2>/dev/null | tail -n 1) | read -r str2

    sp1=$(echo "$str1" | awk -F' ' '{print $1}')
    sp2=$(echo "$str2" | awk -F' ' '{print $1}')
    mib1=$(echo "$str1" | awk -F' ' '{print $5}' | cut -f 1 -d'.')
    mib2=$(echo "$str2" | awk -F' ' '{print $5}' | cut -f 1 -d'.')

    printf "\n$((sp1+sp2)) store paths deleted, $((mib1+mib2)) MiB saved."
  '';
in {
  home.packages = [nix-clean];
}

