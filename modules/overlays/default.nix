{
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  inherit (pkgs.stdenv) isDarwin isLinux mkDerivation;
  # forDarwin =
  #   val:
  #   let
  #     empty = if isList val then [ ] else { };
  #   in
  #   if isDarwin then val else empty;

  # forLinux =
  #   val:
  #   let
  #     empty = if isList val then [ ] else { };
  #   in
  #   if isLinux then val else empty;

  forDarwin =
    val:
    let
      op = if isList val then optionals else mkIf;
    in
    op isDarwin val;

  forLinux =
    val:
    let
      op = if isList e then optionals else mkIf;
    in
    op isLinux val;

  flakeOverlays =
    with inputs;
    [
      nur.overlays.default
      nix-shell-scripts.overlays.default
    ]
    ++ forDarwin [
      nh.overlays.default
    ]
    ++ forLinux [
      hyprpanel.overlay
    ];

  packageOverrides = toList {
    pure-prompt = prev.pure-prompt.overrideAttrs {
      src = prev.fetchFromGitHub {
        owner = "quinneden";
        repo = "pure";
        rev = "refs/heads/nix3-shell-prompt";
        hash = "sha256-y5s/qBZWLKNMnrbN7qGXNJD87yuMtw2EuvrLVvX9qmI=";
      };
    };

    qemu = forDarwin (
      prev.qemu.overrideAttrs (old: {
        patches = old.patches ++ [
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/utmapp/UTM/acbf2ba8cd91f382a5e163c49459406af0b462b7/patches/qemu-9.1.0-utm.patch";
            sha256 = "sha256-S7DJSFD7EAzNxyQvePAo5ZZyanFrwQqQ6f2/hJkTJGA=";
          })
        ];
      })
    );

    ghostty = prev.ghostty.overrideAttrs (old: {
      meta.broken = "";
      patches = (old.patches or [ ]) ++ [
        (prev.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/ghostty-org/ghostty/pull/5370.patch";
          hash = "sha256-GRrkpw+Lxgf45Vpl6dUp0MD4UADVNSvqO5+A7FyqUjo=";
        })
      ];
    });
  };

  packages = toList {
    palera1n = forDarwin (
      mkDerivation (finalAttrs: {
        pname = "palera1n";
        version = "2.1-beta.1";

        src = pkgs.fetchurl {
          url = "https://github.com/${finalAttrs.pname}/${finalAttrs.pname}/releases/download/v${finalAttrs.version}/${finalAttrs.pname}-macos-arm64";
          hash = "sha256-hRoCAaTwpoza2RnWNtDPSbOHJwhiuHh+5KTXWxUbfhM=";
        };

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p "$out/bin"
          install -Dm 755 $src "$out/bin/palera1n"
          runHook postInstall
        '';
      })
    );
  };
in
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = flakeOverlays ++ packageOverrides ++ packages;
  };
}
