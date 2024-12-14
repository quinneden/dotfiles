{
  pkgs,
  inputs,
  secrets,
  ...
}:
{
  # nix
  documentation.nixos.enable = false; # .desktop

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix.settings = {
    access-tokens = [ "github=${secrets.github.token}" ];
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    warn-dirty = false;
    trusted-users = [ "quinn" ];
    extra-substituters = [
      "https://cache.lix.systems"
      "https://wezterm.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
  };

  nix.channel.enable = false;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    # docker.enable = true;
    libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    home-manager
    asahi-bless
    git
    wget
    micro
  ];

  security.sudo.wheelNeedsPassword = false;

  # services
  services = {
    # xserver = {
    #   enable = true;
    #   excludePackages = [ pkgs.xterm ];
    # };
    flatpak.enable = true;
    openssh.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # network
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
    firewall.enable = false;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true;
  };

  # bootloader
  boot = {
    m1n1CustomLogo = pkgs.fetchurl {
      url = "https://qeden.me/bootlogo-snowflake-white.png";
      hash = "sha256-6VpPDZSYD57m4LZRPQuOWtR7z70BQ0A2f2jZgjXDiKs=";
    };
    tmp.cleanOnBoot = true;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };

  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    extractPeripheralFirmware = true;
    peripheralFirmwareDirectory = builtins.fetchTarball {
      url = "https://qeden.me/fw/asahi-firmware-20241024.tar.gz";
      sha256 = "sha256-KOBXP/nA3R1+/8ELTwsmmZ2MkX3lyfp4UTWeEpajWD8=";
    };
  };

  system.stateVersion = "25.05";
}
