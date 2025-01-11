{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    gawk
    gnutar
    ks
    zip
    zstd
    nil
    nix-tree
    cachix
    eza
    nixfmt-rfc-style
    nix-prefetch-github
    zoxide
    tabby-release
    devpod
    mosh
    xz
  ];
}
