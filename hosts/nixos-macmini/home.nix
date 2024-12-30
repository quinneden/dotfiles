{
  pkgs,
  config,
  secrets,
  ...
}:
{

  imports = [
    ./variables.nix

    # Programs
    ../../home-manager/common
    ../../home-manager/nixos/programs/kitty
    ../../home-manager/nixos/programs/qutebrowser
    ../../home-manager/nixos/programs/fetch
    ../../home-manager/nixos/programs/git
    ../../home-manager/nixos/programs/yazi
    ../../home-manager/nixos/programs/markdown
    ../../home-manager/nixos/programs/thunar
    ../../home-manager/nixos/programs/lazygit
    ../../home-manager/nixos/programs/nh
    # ../../home-manager/nixos/programs/zen
    # Scripts
    ../../home-manager/nixos/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home-manager/nixos/system/hyprland
    ../../home-manager/nixos/system/hypridle
    ../../home-manager/nixos/system/hyprlock
    ../../home-manager/nixos/system/hyprpanel
    ../../home-manager/nixos/system/hyprpaper
    ../../home-manager/nixos/system/gtk
    ../../home-manager/nixos/system/wofi
    ../../home-manager/nixos/system/zathura
    ../../home-manager/nixos/system/mime
    ../../home-manager/nixos/system/udiskie
    ../../home-manager/nixos/system/clipman
  ];

  home = {
    homeDirectory = "/home/quinn";

    packages = with pkgs; [
      # Apps
      # discord # Chat
      bitwarden # Password manager
      vlc # Video player

      # Dev
      go
      nodejs
      python3
      jq
      just

      # Utils
      zip
      unzip
      pfetch
      pandoc
      btop

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix
      cava

      pnpm

      nil
      deskflow
      bat
      eza
      fzf
      gptfdisk
      gh
      git-crypt
      git-lfs
      glow
      gnumake
      nixfmt-rfc-style
      pure-prompt
      rclone
      ripgrep
      zoxide
    ];

    file.".profile_picture.png" = {
      source = ./prof.jpg;
    };

    # Don't touch this
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
