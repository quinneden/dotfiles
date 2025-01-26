{ inputs, ... }:
let
  flakeOverlays = with inputs; [
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

    qemu = prev.qemu.overrideAttrs {
      patches = prev.qemu.patches ++ [
        (prev.fetchpatch {
          url = "https://raw.githubusercontent.com/utmapp/UTM/acbf2ba8cd91f382a5e163c49459406af0b462b7/patches/qemu-9.1.0-utm.patch";
          sha256 = "sha256-S7DJSFD7EAzNxyQvePAo5ZZyanFrwQqQ6f2/hJkTJGA=";
        })
      ];
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

    ghostty = prev.ghostty.overrideAttrs (old: {
      meta.broken = "";
      patches = (old.patches or []) ++ [
        (prev.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/ghostty-org/ghostty/pull/5370.patch";
          hash = "sha256-GRrkpw+Lxgf45Vpl6dUp0MD4UADVNSvqO5+A7FyqUjo=";
        })
      ];
    });
  };
in
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = flakeOverlays ++ [ packageOverlays ];
  };
}
