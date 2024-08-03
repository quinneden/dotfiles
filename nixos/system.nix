{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  # nix
  documentation.nixos.enable = false; # .desktop
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["quinn" "root"];
    substituters = [
      "https://nixos-apple-silicon.cachix.org"
      "https://hyprland.cachix.org"
      "https://quinneden.cachix.org"
    ];
    trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:xkpmN/hWmtMvApu5lYaNPy4sUXc/6Qfd+iTjdLX8HZ0="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="
    ];
  };

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    alejandra
    asahi-bless
    btrfs-progs
    home-manager
    micro
    ripgrep
    neovim
    git
    wget
  ];

  security.sudo.wheelNeedsPassword = false;

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };
    flatpak.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # network
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  hardware.asahi = {
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    peripheralFirmwareDirectory = builtins.fetchTarball {
      url = "https://pub-c54a7919db1f4471a55c23fa3d8566f2.r2.dev/firmware.tar.gz";
      sha256 = "0wz4fsczs7lr9hia0nyjfi0hqdrdca2i9b9fjl4b47n5fzl5cqml";
    };
  };

  hardware.graphics = {
    enable = true;
    package = lib.mkDefault config.hardware.asahi.pkgs.mesa-asahi-edge.drivers;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

  # bootloader
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      # timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  system.stateVersion = "24.11";
}
