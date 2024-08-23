{
  pkgs,
  inputs,
  ...
}: let
  operator-mono-lig = pkgs.callPackage ./packages/operator-mono-lig.nix {inherit pkgs;};
  operator-mono-nf = pkgs.callPackage ./packages/operator-mono-nf.nix {inherit pkgs;};
in {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      operator-mono-lig
      operator-mono-nf
    ];
  };
}
