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
      # devenv
      gawk
      gnutar
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
      lazydocker
      lazygit
      ripgrep
      jq
      nodePackages.prettier
    ];
  };
}
