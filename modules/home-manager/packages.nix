{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./packages
    ./scripts
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
      direnv
      nodejs
      vesktop
      rustup
      rustc
      gcc
      glow
      gnumake
      gptfdisk
      lima
      cmake
      openssl
      pkg-config
      zoxide
      vagrant
      python312
      gtrash
    ];
    cli = [
      bat
      cachix
      eza
      fd
      fzf
      gh
      gnupg
      lazydocker
      lazygit
      ripgrep
      jq
      nodePackages.prettier
    ];
  };
}
