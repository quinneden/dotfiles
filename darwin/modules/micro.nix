{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
{
  options.programs.microConf = {
    enable = lib.mkEnableOption "Enable the micro text editor.";
    package = mkPackageOption pkgs "micro" { };

    keybindings = mkOption {
      type = with types; nullOr (attrsOf str);
      default = null;
    };

    settings = mkOption {
      type = with types; nullOr (attrsOf str);
      default = null;
    };

    extraSyntax = mkOption {
      type = with types; nullOr (attrsOf path);
      default = { };
    };
  };

  config =
    let
      cfg = config.programs.microConf;
      inherit (lib.generators) toJSON;
    in
    mkIf cfg.enable {
      home.packages = [ cfg.package ];

      home.file =
        {
          "settings.json" = mkIf (cfg.settings != null) {
            text = toJSON { } cfg.settings;
            target = "$HOME/.config/micro/settings.json";
          };

          "keybindings.json" = mkIf (cfg.keybindings != null) {
            text = toJSON { } cfg.keybindings;
            target = "$HOME/.config/micro/keybindings.json";
          };
        }
        // mkIf (cfg.extraSyntax != null) (
          lib.mapAttrs (name: path: {
            target = "$HOME/.config/micro/syntax/${name}.yaml";
            source = path;
          }) cfg.extraSyntax
        );
    };
}
