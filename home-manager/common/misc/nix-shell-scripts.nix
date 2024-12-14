{ pkgs, lib, ... }:
let
  forDarwin =
    if pkgs.stdenv.isDarwin then
      (with pkgs; [
        nixos-deploy
        darwin-switch
        sec
        wipe-linux
      ])
    else
      [ ];
  forLinux =
    if pkgs.stdenv.isLinux then
      (with pkgs; [
        nix-switch
      ])
    else
      [ ];
in
{
  home.packages =
    (with pkgs; [
      cfg
      commit
      cop
      diskusage
      fuck
      lsh
      mi
      nish
      nix-clean
      nix-get-sha256
      readme
      rm-result
    ])
    ++ forDarwin
    ++ forLinux;
}
