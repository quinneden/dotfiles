{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.colors;

  tintedBase16 = pkgs.stdenv.mkDerivation {
    pname = "tinted-base16-schemes";
    version = "0.11";
    src = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "schemes";
      rev = "refs/heads/spec-0.11";
      hash = "sha256-W4BfjOLksRbHGDluyHntxFacBL2ZAjXAC6RRQWTDsAo=";
      sparseCheckout = [ "base16" ];
    };
    buildPhase = ''
      runHook preBuild
      rm base16/README.md
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      pushd base16 > /dev/null
      cp -r ./. "$out"
      popd > /dev/null
      runHook postInstall
    '';
  };

  importYaml =
    f:
    builtins.fromJSON (
      readFile (pkgs.runCommand "yaml2json" { } "${pkgs.yq}/bin/yq < ${tintedBase16}/${f}.yaml > $out")
    );

  getPalette = i: (importYaml i).palette;
in
{
  options.colors = {
    enable = mkEnableOption "Enable colors support" // {
      default = config.stylix.enable;
    };

    package = mkOption {
      type = types.package;
      default = tintedBase16;
    };

    palette = mkOption {
      type =
        with types;
        nullOr (oneOf [
          attrs
          str
        ]);
      default = null;
    };
  };

  config =
    let
      colorAttrs = if (isAttrs cfg.palette) then cfg.palette else getPalette cfg.palette;
    in
    mkIf cfg.enable {
      stylix.base16Scheme = mkIf (cfg.palette != null) colorAttrs;
    };
}
