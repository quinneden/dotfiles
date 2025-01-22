{ inputs, ... }:
let
  flakeOverlays = with inputs; [
    lix-module.overlays.default
    nh.overlays.default
    nix-shell-scripts.overlays.default
    nur.overlays.default
  ];

  packageOverlays = final: prev: {
    pure-prompt = prev.pure-prompt.overrideAttrs {
      src = prev.fetchFromGitHub {
        owner = "quinneden";
        repo = "pure";
        rev = "refs/heads/nix3-shell-prompt";
        hash = "sha256-y5s/qBZWLKNMnrbN7qGXNJD87yuMtw2EuvrLVvX9qmI=";
      };
    };

    # qemu = prev.qemu.overrideAttrs {
    #   patches = prev.qemu.patches ++ [
    #     (prev.fetchpatch {
    #       url = "https://raw.githubusercontent.com/utmapp/UTM/acbf2ba8cd91f382a5e163c49459406af0b462b7/patches/qemu-9.1.0-utm.patch";
    #       sha256 = "sha256-S7DJSFD7EAzNxyQvePAo5ZZyanFrwQqQ6f2/hJkTJGA=";
    #     })
    #   ];
    # };

    nerd-font-patcher = prev.nerd-font-patcher.overrideAttrs rec {
      version = "3.3.0";
      src = prev.fetchzip {
        url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FontPatcher.zip";
        sha256 = "sha256-/LbO8+ZPLFIUjtZHeyh6bQuplqRfR6SZRu9qPfVZ0Mw=";
        stripRoot = false;
      };
    };

    palera1n = prev.stdenv.mkDerivation (finalAttrs: rec {
      pname = "palera1n";
      version = "2.1-beta.1";

      src = prev.fetchurl {
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
