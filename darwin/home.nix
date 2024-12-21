{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../home-manager/common
    ../home-manager/darwin
    inputs.mac-app-util.homeManagerModules.default
  ];

  home.file.".hushlogin".text = "";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.man.enable = false;

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
