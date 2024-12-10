{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nh;
in
{
  meta.maintainers = [ lib.maintainers.viperML ];

  options.programs.nh = {
    enable = lib.mkEnableOption "nh, yet another Nix CLI helper";

    package = lib.mkPackageOption pkgs "nh" { };

    flake = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        The path that will be used for the `NH_FLAKE` environment variable.

        `NH_FLAKE` is used by nh as the default flake for performing actions, like `nh darwin switch`.
      '';
    };

    clean = {
      enable = lib.mkEnableOption "periodic garbage collection with nh clean all";

      # dates = lib.mkOption {
      #   type = lib.types.submodule;
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

      extraArgs = lib.mkOption {
        type = lib.types.singleLineStr;
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
      # Not strictly required but probably a good assertion to have
      {
        assertion = cfg.clean.enable -> cfg.enable;
        message = "programs.nh.clean.enable requires programs.nh.enable";
      }

      {
        assertion = (cfg.flake != null) -> !(lib.hasSuffix ".nix" cfg.flake);
        message = "nh.flake must be a directory, not a nix file";
      }
    ];

    environment = lib.mkIf cfg.enable {
      systemPackages = [ cfg.package ];
      variables = lib.mkIf (cfg.flake != null) {
        NH_FLAKE = cfg.flake;
      };
    };

    # systemd = lib.mkIf cfg.clean.enable {
    #   services.nh-clean = {
    #     description = "Nh clean";
    #     script = "exec ${lib.getExe cfg.package} clean all ${cfg.clean.extraArgs}";
    #     startAt = cfg.clean.dates;
    #     path = [ config.nix.package ];
    #     serviceConfig.Type = "oneshot";
    #   };
    #   timers.nh-clean = {
    #     timerConfig = {
    #       Persistent = true;
    #     };
    #   };
    # };

    launchd = lib.mkIf cfg.clean.enable {
      daemons = {
        "nh-clean" = {
          command = "${lib.getExe cfg.package} clean all ${cfg.clean.extraArgs}";
          environment = lib.mkIf (cfg.flake != null) {
            NH_FLAKE = cfg.flake;
          };
          serviceConfig.RunAtLoad = false;
          serviceConfig.StartCalendarInterval = [
            {
              Weekday = 1;
            }
          ];
          # serviceConfig.UserName = cfg.user;
        };
      };
    };
  };
}
