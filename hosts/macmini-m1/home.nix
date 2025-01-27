{
  pkgs,
  ...
}:
{

  imports = [
    ./variables.nix

    # Programs
    ../../home-manager/common
    ../../home-manager/nixos/programs/fetch
    ../../home-manager/nixos/programs/firefox
    ../../home-manager/nixos/programs/git
    ../../home-manager/nixos/programs/kitty
    ../../home-manager/nixos/programs/lazygit
    ../../home-manager/nixos/programs/markdown
    ../../home-manager/nixos/programs/nh
    ../../home-manager/nixos/programs/thunar
    ../../home-manager/nixos/scripts
    ../../home-manager/nixos/system/clipman
    ../../home-manager/nixos/system/hypridle
    ../../home-manager/nixos/system/hyprland
    ../../home-manager/nixos/system/hyprlock
    ../../home-manager/nixos/system/hyprpanel
    ../../home-manager/nixos/system/hyprpaper
    ../../home-manager/nixos/system/mime
    ../../home-manager/nixos/system/ssh
    ../../home-manager/nixos/system/udiskie
    ../../home-manager/nixos/system/wofi
    ../../home-manager/nixos/system/zathura
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
