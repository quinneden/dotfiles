{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    aria2
    gawk
    gnutar
    xz
    zip
    zstd
    nil
    nix-tree
    cachix
    eza
    nixfmt-rfc-style
    inputs.nix-shell-scripts.packages.${system}.default
    zoxide
  ];
}
