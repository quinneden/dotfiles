{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nx-switch.nix
    ./scripts/vault.nix
  ];

  packages = with pkgs; {
    linux = [
      (mpv.override {scripts = [mpvScripts.mpris];})
      cachix
      fragments
      gnome-secrets
      nodejs
      vesktop
    ];
    cli = [
      bat
      eza
      fd
      fzf
      lazydocker
      lazygit
      ripgrep
    ];
  };
}
