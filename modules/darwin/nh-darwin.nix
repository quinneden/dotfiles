{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nh;
  inherit (pkgs) runCommand;
in
with lib;
{
  meta.maintainers = [ maintainers.quinneden ];

  options.programs.nh = {
    enable = mkEnableOption "nh, yet another Nix CLI helper";

    package = mkPackageOption pkgs "nh" { };

    flake = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The path that will be used for the `NH_FLAKE` environment variable.

        `NH_FLAKE` is used by nh as the default flake for performing actions, like `nh darwin switch`.
      '';
    };

    clean = {
      enable = mkEnableOption "periodic garbage collection with nh clean all";

      # dates = mkOption {
      #   type = types.submodule;
      #   default = {
      #     StartCalendarInterval = {
      #       Weekday = 1;
      #     };
      #   };
      #   description = ''
      #     How often cleanup is performed. Passed to launchd.

      #     The format is described in
      #     {manpage}`launchd.plist(5)`.
      #   '';
      # };

      extraArgs = mkOption {
        type = types.singleLineStr;
        default = "";
        example = "--keep 5 --keep-since 3d";
        description = ''
          Options given to nh clean when the service is run automatically.

          See `nh clean all --help` for more information.
        '';
      };
    };
  };

  config = {
    warnings =
      if (!(cfg.clean.enable -> !config.nix.gc.automatic)) then
        [
          "programs.nh.clean.enable and nix.gc.automatic are both enabled. Please use one or the other to avoid conflict."
        ]
      else
        [ ];

    assertions = [
      {
        assertion = cfg.clean.enable -> cfg.enable;
        message = "programs.nh.clean.enable requires programs.nh.enable";
      }

      {
        assertion = (cfg.flake != null) -> !(hasSuffix ".nix" cfg.flake);
        message = "nh.flake must be a directory, not a nix file";
      }
    ];

    environment = mkIf cfg.enable {
      systemPackages = [ cfg.package ];
      variables.NH_FLAKE =
        if (cfg.flake != null) then
          cfg.flake
        else
          readFile (runCommand "hostname" { } "printf $(/bin/hostname -s) > $out");
    };

    launchd = mkIf cfg.clean.enable {
      daemons = {
        "nh-clean" = {
          command = "${getExe cfg.package} clean all ${cfg.clean.extraArgs}";
          environment = mkIf (cfg.flake != null) {
            NH_FLAKE =
              if (cfg.flake != null) then
                cfg.flake
              else
                readFile (runCommand "hostname" { } "printf $(/bin/hostname -s) > $out");
          };
          serviceConfig.RunAtLoad = false;
          serviceConfig.StartCalendarInterval = [
            {
              Weekday = 1;
            }
          ];
        };
      };
    };
  };
}
