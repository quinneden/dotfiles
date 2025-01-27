{ config, ... }:
{
  time.timeZone = config.var.timeZone;
  i18n.defaultLocale = config.var.defaultLocale;
  # i18n.defaultLocalSettings = {
  #   LC_ADDRESS = config.var.defaultLocal;
  #   LC_IDENTIFICATION = config.var.defaultLocal;
  #   LC_MEASUREMENT = config.var.defaultLocal;
  #   LC_MONETARY = config.var.defaultLocal;
  #   LC_NAME = config.var.defaultLocal;
  #   LC_NUMERIC = config.var.defaultLocal;
  #   LC_PAPER = config.var.defaultLocal;
  #   LC_TELEPHONE = config.var.defaultLocal;
  #   LC_TIME = config.var.defaultLocal;
  # };
}
