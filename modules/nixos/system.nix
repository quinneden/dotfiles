{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  # nix
  documentation.nixos.enable = false;

  boot = {
    supportedFilesystems = ["zfs"];
    zfs.forceImportRoot = false;
  };

  nix.settings = {
    access-tokens = ["github=${secrets.github.api}"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    trusted-users = ["quinn" "root"];
    warn-dirty = false;
    substituters = [
      "${secrets.cachix.nixos-asahi.url}"
    ];
    trusted-public-keys = [
      "${secrets.cachix.nixos-asahi.public-key}"
    ];
  };

  # virtualisation
  programs.virt-manager.enable = false;
  virtualisation = {
    podman.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  # direnv
  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    enableZshIntegration = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    alejandra
    btrfs-progs
    home-manager
    micro
    ripgrep
    neovim
    git
    wget
  ];

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };
    flatpak.enable = true;
    openssh.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

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
    firewall.enable = false;
    hostId = "a25f4bea";
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # swap
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  system.stateVersion = "24.11";
}
