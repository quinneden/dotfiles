{pkgs, ...}: let
  sec = pkgs.writeShellScriptBin "sec" (builtins.readFile ./sec.sh);
  wipe-linux = pkgs.writeShellScriptBin "wipe-linux" (builtins.readFile ./wipe-linux.sh);
  nix-clean = pkgs.writeShellScriptBin "nix-clean" (builtins.readFile ./nix-clean.sh);
in {
  home.packages = with pkgs; [
    sec
    wipe-linux
    nix-clean
  ];
}
