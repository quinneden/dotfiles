{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../home-manager/darwin
    ../home-manager/git.nix
    ../home-manager/lf.nix
    ../home-manager/micro.nix
    ../home-manager/nvim.nix
    ../home-manager/packages.nix
    ../home-manager/tmux.nix
  ];

  news.display = "show";

  home.file.".hushlogin".text = "";

  fonts.fontconfig.enable = true;

  home.packages = let
    nerdfonts = pkgs.nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "FantasqueSansMono"
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
        "VictorMono"
      ];
    };
  in [nerdfonts];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
