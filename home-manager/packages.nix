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
      vesktop
      xz
      zip
      zstd
    ];
    linux = [
      (mpv.override {scripts = [mpvScripts.mpris];})
      hdrop
      nodejs
      vesktop
      rustup
      rustc
      gcc
      gnumake
      cmake
      openssl
      pkg-config
    ];
    cli = [
      bat
      cachix
      eza
      fd
      fzf
      gh
      lazydocker
      lazygit
      ripgrep
    ];
  };
}
