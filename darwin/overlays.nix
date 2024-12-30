{
  lib,
  pkgs,
  self,
  inputs,
  ...
}:
let
  flakeOverlays = with inputs; [
    lix-module.overlays.default
    nh.overlays.default
    nix-shell-scripts.overlays.default
    nur.overlays.default
  ];

  packageOverlays = final: prev: {
    betterdisplaycli =
      let
        forkpkgs = import inputs.forkpkgs { inherit (pkgs) system; };
      in
      forkpkgs.betterdisplaycli;

    nh = prev.nh.overrideAttrs rec {
      version = "4.0.0-beta.5";
      src = pkgs.fetchFromGitHub {
        owner = "viperML";
        repo = "nh";
        tag = "v${version}";
        hash = "sha256-B3PK+e717FdrQXhg53DwTPWLY458yGYsH20tYj0pgzU=";
      };
    };

    tabby-release = self.packages.aarch64-darwin.tabby-release;

    pure-prompt = prev.pure-prompt.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "quinneden";
        repo = "pure";
        rev = "refs/heads/nix3-shell-prompt";
        hash = "sha256-y5s/qBZWLKNMnrbN7qGXNJD87yuMtw2EuvrLVvX9qmI=";
      };
    };

    qemu = prev.qemu.overrideAttrs {
      patches = prev.qemu.patches ++ [
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/utmapp/UTM/acbf2ba8cd91f382a5e163c49459406af0b462b7/patches/qemu-9.1.0-utm.patch";
          sha256 = "sha256-S7DJSFD7EAzNxyQvePAo5ZZyanFrwQqQ6f2/hJkTJGA=";
        })
      ];
    };

    nerd-font-patcher = prev.nerd-font-patcher.overrideAttrs rec {
      version = "3.3.0";
      src = pkgs.fetchzip {
        url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FontPatcher.zip";
        sha256 = "sha256-/LbO8+ZPLFIUjtZHeyh6bQuplqRfR6SZRu9qPfVZ0Mw=";
        stripRoot = false;
      };
    };

    palera1n = pkgs.stdenv.mkDerivation (finalAttrs: rec {
      pname = "palera1n";
      version = "2.1-beta.1";
      src = pkgs.fetchurl {
        url = "https://github.com/${pname}/${pname}/releases/download/v${finalAttrs.version}/${pname}-macos-arm64";
        hash = "sha256-hRoCAaTwpoza2RnWNtDPSbOHJwhiuHh+5KTXWxUbfhM=";
      };
      dontUnpack = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/bin"
        install -Dm 755 $src "$out"/bin/palera1n
        runHook postInstall
      '';
    });
  };
in
{
  nixpkgs.overlays = flakeOverlays ++ [ packageOverlays ];
}
