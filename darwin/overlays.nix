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
          sha256 = "sha256-NNExO4lMKQoqLqsssSFkMJKHnFMXagjPzOla2DccS+g=";
        })
      ];
    };

    ungoogled-chromium = prev.ungoogled-chromium.overrideAttrs {
      meta.platforms = prev.platforms ++ lib.platforms.darwin;
    };
  };
in
{
  nixpkgs.overlays = flakeOverlays ++ [ packageOverlays ];
}
