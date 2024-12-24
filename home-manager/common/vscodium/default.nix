{
  inputs,
  lib,
  pkgs,
  theme,
  ...
}:

{
  programs.vscode =
    let
      extensions = [ ] ++ (import ./extensions/general.nix { inherit inputs pkgs; });

      keybindings = [ ] ++ (import ./settings/keybindings.nix);

      userSettings =
        { }
        // (import ./settings/four-tabs-langs.nix { inherit lib; })
        // (import ./settings/editor.nix)
        // (import ./settings/workbench.nix)
        // (import ./settings/window.nix)
        // (import ./settings/misc.nix)
        // (import ./settings/lsp.nix { inherit lib pkgs; });
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
