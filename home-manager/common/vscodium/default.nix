{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # inherit (builtins) readFile fromJSON;
  # inherit (pkgs) fetchurl;
  # inherit (lib) mkIf;

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
        // (import ./settings/editor.nix)
        // (import ./settings/workbench.nix)
        // (import ./settings/window.nix)
        // (import ./settings/misc.nix { inherit pkgs; })
        // (import ./settings/lsp.nix { inherit pkgs lib; });
    in
    {
      enable = true;
      package = nullPkg;

      inherit
        extensions
        keybindings
        userSettings
        ;
    };
}
