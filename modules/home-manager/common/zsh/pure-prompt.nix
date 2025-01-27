{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.zsh.pure-prompt;
in
with lib;
{
  options.programs.pure-prompt = {
    enable = mkEnableOption "Pretty, minimal and fast ZSH prompt";

    package = mkPackageOption pkgs "pure-prompt" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.zsh.initExtra = ''
      fpath+=(${cfg.package}/share/zsh/site-functions)
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };
}
