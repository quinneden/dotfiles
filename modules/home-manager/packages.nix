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
      apfsprogs
      direnv
      nodejs
      vesktop
      rustup
      rustc
      gcc
      glow
      gnumake
      gptfdisk
      hfsprogs
      lima
      cmake
      openssl
      pkg-config
      pure-prompt
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
