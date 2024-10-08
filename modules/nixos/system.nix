{
  pkgs,
  inputs,
  secrets,
  config,
  lib,
  ...
}: {
  # nix
  documentation.nixos.enable = false;

  nix.settings = {
    access-tokens = ["github=${secrets.github.api}"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    trusted-users = ["quinn"];
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    warn-dirty = false;
    substituters = [
      # "${secrets.cachix.nixos-asahi.url}"
      "https://cache.lix.systems"
    ];
    # extra-trusted-substituters = config.nix.settings.substituters;
    trusted-public-keys = [
      # "${secrets.cachix.nixos-asahi.public-key}"
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };

  # ssh
  programs.ssh.startAgent = true;

  programs.gnupg.agent = {
     enable = true;
     pinentryPackage = pkgs.pinentry-curses;
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
    apfsprogs
    hfsprogs
    pinentry-curses
    btrfs-progs
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
    memoryPercent = 300;
  };

  system.stateVersion = "24.11";
}
