{ pkgs, ... }:
{
  imports = [
    # ./misc/floorp.nix
    ./misc/git.nix
    ./micro/old.nix
    ./misc/rclone.nix
    ./vscodium
    ./zsh
  ];

  home.packages = with pkgs.nix-shell-scripts; [
    a2dl
    alphabetize
    cfg
    clone
    colortable
    commit
    cop
    darwin-switch
    diskusage
    del
    lsh
    mi
    nish
    nix-clean
    nix-switch
    nixhash
    nixos-deploy
    readme
    rm-result
    swatch
    wipe-linux
  ];
}
