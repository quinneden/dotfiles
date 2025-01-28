{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
in
with lib;
{
  imports = [ ./micro.nix ];

  programs.micro = {
    enable = true;

    extraSyntax = {
      nix = ./syntax/nix.yaml;
    };

    plugins = {
      micro-autofmt = {
        url = "https://github.com/quinneden/micro-autofmt";
        hash = "sha256-9SggIGWb718yKN5PvebbwYH1EIT/Weu4DkpRJntw5B8=";
      };
    };

    settings = {
      autoclose = true;
      autosu = true;
      colorscheme = "cuddles";
      comment = true;
      diff = true;
      ftoptions = true;
      initlua = true;
      linter = true;
      literate = true;
      pluginrepos = [
        "https://github.com/quinneden/micro-autofmt/raw/refs/heads/main/repo.json"
        "https://github.com/sparques/micro-quoter/raw/refs/heads/master/repo.json"
        "https://github.com/AndCake/micro-plugin-lsp/raw/refs/heads/master/repo.json"
      ];
      parsecursor = true;
      reload = "auto";
      rmtrailingws = true;
      saveundo = true;
      tabhighlight = true;
      tabsize = 2;
      tabstospaces = true;
    };
  };

  home.file."micro-colors" = {
    recursive = true;
    target = "${config.xdg.configHome}/micro/colorschemes";
    source = inputs.micro-colors-nix.packages.${pkgs.system}.default;
  };
}
