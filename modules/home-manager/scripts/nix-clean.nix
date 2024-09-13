{pkgs, ...}: let
  nix-clean = pkgs.writeShellScriptBin "nix-clean" ''
    echo "Collecting garbage from nix store..."
    read -ra arr1 < <(nix-collect-garbage -d 2>/dev/null)
    read -ra arr2 < <(sudo nix-collect-garbage -d 2>/dev/null)

    read -r store_paths < <(awk "BEGIN {print ''${arr1[0]}+''${arr2[0]}; exit}")
    read -r mib_float < <(awk "BEGIN {print ''${arr1[4]}+''${arr2[4]}; exit}")

    echo
    echo "$store_paths store paths deleted, $mib_float MiB saved."
  '';
in {home.packages = [nix-clean];}
