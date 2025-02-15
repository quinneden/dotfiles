{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
      python3Packages.black
      python3Packages.python-lsp-server
    ];

    extensions = [
      "astro"
      "nix"
      "oh-lucy"
      "panda-theme"
      "pylsp"
    ];

    # userKeymaps = import ./keymaps.nix;
    userSettings = import ./settings.nix;
  };
}
