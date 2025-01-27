{ pkgs, ... }:
{
  boot = {
    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    kernelParams = [
      "quiet"
      "splash"
      "systemd.show_status=auto"
      "rd.systemd.show_status=auto"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot.enable = true;
      timeout = 0; # Spam space to enter the boot menu
    };

    m1n1CustomLogo = pkgs.fetchurl {
      url = "https://f.qeden.me/bootlogo-snowflake-white.png";
      hash = "sha256-6VpPDZSYD57m4LZRPQuOWtR7z70BQ0A2f2jZgjXDiKs=";
    };

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    tmp.cleanOnBoot = true;
  };
}
