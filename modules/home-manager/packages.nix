{pkgs, inputs, ...}: {
  imports = [
    ./modules/packages.nix
    ./packages
    ./scripts
  ];

  packages = with pkgs; {
    darwin = [
      aria2
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
      git-crypt
      glow
      gnumake
      gptfdisk
      hfsprogs
      lima
      cmake
      openssl
      pass
      pkg-config
      pure-prompt
      rclone
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
      inputs.alejandra.defaultPackage.${system}
    ];
  };
}
