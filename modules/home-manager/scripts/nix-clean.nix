{pkgs, ...}: let
  nix-clean = pkgs.writeShellScriptBin "nix-clean" ''
    echo "Collecting garbage from nix store..."
    nix-collect-garbage -d 2>/dev/null | read -r str1
    sudo nix-collect-garbage -d 2>/dev/null | read -r str2

    store_paths=$(($(awk -F' ' '{print $1}' <<<"$str1")+$(awk -F' ' '{print $1}' <<<"$str2")))
    mib_saved=$(($(awk -F' ' '{print $5}' <<<"$str1")+$(awk -F' ' '{print $5}' <<<"$str2")))

    echo "\n$store_paths store paths deleted, $mib_saved MiB saved."
  '';
in {home.packages = [nix-clean];}
