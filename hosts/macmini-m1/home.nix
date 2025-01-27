{
  pkgs,
  ...
}:
{

  imports = [
    ./variables.nix

    # Programs
    ../../modules/home-manager/common
    ../../modules/home-manager/nixos/programs/fetch
    ../../modules/home-manager/nixos/programs/firefox
    ../../modules/home-manager/nixos/programs/kitty
    ../../modules/home-manager/nixos/programs/lazygit
    ../../modules/home-manager/nixos/programs/markdown
    ../../modules/home-manager/nixos/programs/nh
    ../../modules/home-manager/nixos/programs/thunar
    ../../modules/home-manager/nixos/scripts
    ../../modules/home-manager/nixos/system/clipman
    ../../modules/home-manager/nixos/system/hypridle
    ../../modules/home-manager/nixos/system/hyprland
    ../../modules/home-manager/nixos/system/hyprlock
    ../../modules/home-manager/nixos/system/hyprpanel
    ../../modules/home-manager/nixos/system/hyprpaper
    ../../modules/home-manager/nixos/system/mime
    ../../modules/home-manager/nixos/system/ssh
    ../../modules/home-manager/nixos/system/udiskie
    ../../modules/home-manager/nixos/system/wofi
    ../../modules/home-manager/nixos/system/zathura
  ];

  home = {
    homeDirectory = "/home/quinn";

    packages = with pkgs; [
      bitwarden # Password manager
      vlc # Video player
      go
      nodejs
      python3
      jq
      just
      zip
      unzip
      pfetch
      pandoc
      btop
      peaclock
      cbonsai
      pipes
      cmatrix
      cava
      pnpm
      nil
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

    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
