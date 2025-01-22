{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    cachix
    eza
    gawk
    gnutar
    ks
    mosh
    nil
    nix-prefetch-github
    nix-tree
    nixfmt-rfc-style
    xz
    zip
    zoxide
    zstd
  ];
}
