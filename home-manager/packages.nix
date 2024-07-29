{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nx-switch.nix
    ./scripts/vault.nix
  ];

  packages = with pkgs; {
    darwin = [
      alejandra
      aria2
      devenv
      gawk
      gnutar
      xz
      zip
      zstd
    ];
    linux = [
      (mpv.override {scripts = [mpvScripts.mpris];})
      fragments
      gnome-secrets
      hdrop
      nodejs
      vesktop
    ];
    cli = [
      bat
      cachix
      eza
      fd
      fzf
      lazydocker
      lazygit
      ripgrep
    ];
  };
}
