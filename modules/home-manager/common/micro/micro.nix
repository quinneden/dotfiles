{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.programs.micro;

  jsonFormat = pkgs.formats.json { };

  inherit (pkgs) fetchgit;
in
{
  options = {
    programs.micro = {
      extraSyntax = mkOption {
        type = types.attrs;
        default = [ ];
      };

      keybindings = mkOption {
        type = jsonFormat.type;
        default = { };
        example = literalExpression ''
          {
            "Ctrl-y" = "Undo";
            "Ctrl-z" = "Redo";
          }
        '';
        description = ''
          Configuration written to
          {file}`$XDG_CONFIG_HOME/micro/settings.json`. See
          <https://github.com/zyedidia/micro/blob/master/runtime/help/options.md>
          for supported values.
        '';
      };

      plugins = mkOption {
        type =
          with types;
          nullOr (
            attrsOf (submodule {
              options = {
                url = mkOption { type = str; };
                hash = mkOption { type = str; };
              };
            })
          );

        default = null;
        description = "Additional plugins to fetch and extract into ~/.config/micro/plug/<plugin-name>.";
        example = literalExpression ''
          micro-autofmt = {
            url = "https://github.com/quinneden/micro-autofmt";
            rev = "refs/heads/main";
          };
        '';
      };
    };

    # colors = mkOption {
    #   type = with types; listOf attrs;
    #   default = [ ];
    #   description = "List of colorscheme yaml files to install to ~/.config/micro/colorschemes.";
    #   example = literalExpression ''
    #     [
    #       {
    #         name = "cuddles";
    #         source = pkgs.fetchgit {
    #           url = <url>;
    #           hash = <hash>;
    #         };
    #       }
    #     ]
    #   '';
    # };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mkIf (cfg.keybindings != null) {
      "micro/bindings.json".source = jsonFormat.generate "micro-keybindings" cfg.keybindings;
    };

    home.file = (
      mkIf (cfg.plugins != null) (
        mapAttrs (name: plug: {
          recursive = true;
          target = ".config/micro/plug/" + name;
          source = fetchgit {
            url = plug.url;
            hash = plug.hash;
          };
        }) cfg.plugins
      )
      // (mkIf (cfg.extraSyntax != null) (
        lib.mapAttrs (name: path: {
          target = ".config/micro/syntax/" + baseNameOf path;
          source = path;
        }) cfg.extraSyntax
      ))
    );
  };
}
