{
  systemd.services.NetworkManager-wait-online.enable = false;

  networking = {
    hostName = "nixos-macmini";

    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
        General.EnableNetworkConfiguration = true;
      };
    };

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    # firewall.enable = false;
  };
}
