{ pkgs, ... }:
{
  boot = {
    bootspec.enable = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    tmp.cleanOnBoot = true;

    m1n1CustomLogo = pkgs.fetchurl {
      url = "https://qeden.me/bootlogo-snowflake-white.png";
      hash = "sha256-6VpPDZSYD57m4LZRPQuOWtR7z70BQ0A2f2jZgjXDiKs=";
    };
  };
}
