{
  pkgs,
  inputs,
  system,
  ...
}:
{
  nixpkgs.overlays =
    let
      miscOverlays = final: prev: {
        xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (
          finalAttrs: prevAttrs: {
            src = pkgs.fetchFromGitHub {
              owner = "leon-erd";
              repo = prevAttrs.pname;
              rev = "424287fa0b2c59096e38534efdbd9a6bec13aead";
              sha256 = "sha256-4igGdq8CpWbTmDVVKZwIs76eOTESDrGO5qa0m/BhYP4=";
            };
            buildInputs = prevAttrs.buildInputs ++ [ pkgs.libxkbcommon ];
          }
        );
      };
    in
    ([
      miscOverlays
    ])
    ++ (with inputs; [
      nix-shell-scripts.overlays.default
      hyprpanel.overlay
      nur.overlays.default
    ]);
}
