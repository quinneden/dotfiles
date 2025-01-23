{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  nullPkg = pkgs.emptyDirectory.overrideAttrs {
    inherit (pkgs.vscodium)
      passthru
      pname
      version
      ;
    buildCommand = "mkdir -p $out/bin; printf 'echo \"dummy vscodium package for home-manager.\"' > $out/bin/codium";
    meta = {
      mainProgram = null;
    } // pkgs.vscodium.meta;
  };
in
{
  programs.vscode =
    let
      extensions = [ ] ++ (import ./extensions.nix { inherit inputs pkgs; });

      keybindings = [ ] ++ (import ./settings/keybindings.nix { inherit lib; });

      userSettings =
        { }
        // (import ./settings/four-tabs-langs.nix { inherit lib; })
        // (import ./settings/editor.nix { inherit lib; })
        // (import ./settings/workbench.nix { inherit lib pkgs; })
        // (import ./settings/window.nix)
        // (import ./settings/misc.nix { inherit lib pkgs; })
        // (import ./settings/lsp.nix { inherit lib pkgs; });
    in
    {
      enable = true;
      package = if isDarwin then nullPkg else pkgs.vscodium;

      inherit
        extensions
        keybindings
        userSettings
        ;
    };
}
