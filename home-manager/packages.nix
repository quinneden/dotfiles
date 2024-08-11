{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts
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
      direnv
      hdrop
      nodejs
      vesktop
      rustup
      rustc
      gcc
      gnumake
      gptfdisk
      cmake
      openssl
      pkg-config
      zoxide
      vagrant
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
      jq
      nodePackages-pretti
    ];
  };
}
