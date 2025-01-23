{
  programs = {
    man.enable = false;

    nh = {
      enable = true;
      flake = "/Users/quinn/.dotfiles";
      clean.enable = true;
      clean.extraArgs = "--keep-since 3d";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };
}
