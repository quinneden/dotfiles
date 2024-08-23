{pkgs, ...}: let
  mi = pkgs.writeShellScriptBin "mi" ''
    echo -ne '\e[6 q'
    micro $@
    echo -ne '\e[2 q'
  '';
in {
  home.packages = [mi];
}
