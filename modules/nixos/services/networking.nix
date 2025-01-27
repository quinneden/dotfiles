{
  networking = {
    hostName = "nixos-macmini";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };

    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
        General.EnableNetworkConfiguration = true;
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        8081
        4321
      ];
      checkReversePath = "loose";
    };
  };
}
