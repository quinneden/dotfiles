{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.vscode =
    let
      extensions = [ ] ++ (import ./extensions.nix { inherit inputs pkgs; });

      keybindings = [ ] ++ (import ./settings/keybindings.nix { inherit lib; });

      userSettings =
        { }
        // (import ./settings/four-tabs-langs.nix { inherit lib; })
        // (import ./settings/editor.nix)
        // (import ./settings/workbench.nix)
        // (import ./settings/window.nix)
        // (import ./settings/misc.nix { inherit pkgs; })
        // (import ./settings/lsp.nix { inherit pkgs lib; });
    in
    {
      enable = true;
      package = pkgs.vscodium;

      inherit
        extensions
        keybindings
        userSettings
        ;
    };
}
