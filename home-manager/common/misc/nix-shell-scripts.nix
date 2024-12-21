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
      alphabetize
      cfg
      commit
      cop
      diskusage
      fuck
      lsh
      mi
      nixhash
      nish
      nix-clean
      readme
      rm-result
    ])
    ++ forDarwin
    ++ forLinux;
}
