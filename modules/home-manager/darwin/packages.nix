{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cachix
    eza
    gawk
    gnutar
    ks
    nil
    nix-prefetch-github
    nix-shell-scripts.darwin-switch
    nix-shell-scripts.lsh
    nix-shell-scripts.wipe-linux
    nix-tree
    nixfmt-rfc-style
    qemu
    zoxide
  ];
}
