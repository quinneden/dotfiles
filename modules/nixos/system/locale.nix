{ lib, ... }:
{
  time = {
    timeZone = lib.mkDefault "America/Los_Angeles";
    hardwareClockInLocalTime = lib.mkDefault true;
  };
}
