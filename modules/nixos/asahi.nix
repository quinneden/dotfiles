{ pkgs, ... }:
{
  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    extractPeripheralFirmware = true;
    peripheralFirmwareDirectory = builtins.fetchTarball {
      url = "https://f.qeden.me/fw/firmware-2024-12-21.tar.gz";
      sha256 = "sha256-zQejBrdZ98nb/HZOX3jFuH9vM+y/782yxUVbe26LSys=";
    };
  };

  environment.systemPackages = with pkgs; [
    asahi-bless
    asahi-btsync
    asahi-fwextract
  ];
}
