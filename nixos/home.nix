{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../home-manager/nvim.nix
    ../home-manager/ags.nix
    ../home-manager/blackbox.nix
    ../home-manager/browser.nix
    ../home-manager/dconf.nix
    ../home-manager/distrobox.nix
    ../home-manager/git.nix
    ../home-manager/hyprland.nix
    ../home-manager/lf.nix
    # ../home-manager/micro.nix
    ../home-manager/packages.nix
    ../home-manager/sh.nix
    ../home-manager/starship.nix
    ../home-manager/theme.nix
    ../home-manager/tmux.nix
    ../home-manager/wezterm.nix
    ../home-manager/alacritty.nix
    ../home-manager/kitty.nix
    ../home-manager/vscodium.nix
  ];

  news.display = "show";

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  gtk.gtk3.bookmarks = let
    home = config.home.homeDirectory;
  in [
    "file://${home}/Documents"
    "file://${home}/Pictures"
    "file://${home}/Downloads"
    "file://${home}/Desktop"
    "file://${home}/workdir Workdir"
    "file://${home}/.dotfiles Dotfiles"
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
