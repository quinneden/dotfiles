{ config, ... }:
{
  programs.nh = {
    enable = true;
    clean.enable = config.var.autoGarbageCollector;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
}
