{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    aria2
    gawk
    gnutar
    ks
    xz
    zip
    zstd
    nil
    nix-tree
    cachix
    eza
    nixfmt-rfc-style
    zoxide
    tabby-release
    devpod
    mosh
  ];
}
