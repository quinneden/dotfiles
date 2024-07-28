{pkgs, ...}: let
  operator-mono = pkgs.callPackage ./packages/operator-mono.nix {inherit pkgs;};
in {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      operator-mono
    ];
  };
}
