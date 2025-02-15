{ pkgs, ... }:
{
  home.packages =
    (with pkgs.nix-shell-scripts; [
      a2dl
      alphabetize
      cfg
      clone
      colortable
      commit
      cop
      diskusage
      del
      mi
      nish
      nix-clean
      nixhash
      nixos-deploy
      readme
      rm-result
      swatch
    ])
    ++ (with pkgs; [
      nix-fast-build
      nix-prefetch-git
      nix-prefetch-github
    ]);
}
