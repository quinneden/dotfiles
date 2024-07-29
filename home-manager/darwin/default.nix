{
  imports =
    [(import ./starship.nix)]
    ++ [(import ./zsh.nix)]
    ++ [(import ./scripts)];
}
