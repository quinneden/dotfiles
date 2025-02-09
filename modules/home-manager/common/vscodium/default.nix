{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;

  vscodiumDummy =
    pkgs.runCommand "vscodium-dummy"
      {
        inherit (pkgs.vscodium)
          passthru
          pname
          version
          meta
          ;
      }
      ''
        mkdir -p "$out/bin"
        echo "true" > "$out/bin/codium"
        chmod +x "$out/bin/codium"
      '';
in
with lib;
{
  programs.vscode =
    let
      extensions = [ ] ++ (import ./extensions.nix { inherit inputs pkgs; });

      keybindings = [ ] ++ (import ./settings/keybindings.nix { inherit lib pkgs; });

      userSettings =
        { }
        // (import ./settings/four-tabs-langs.nix { inherit lib; })
        // (import ./settings/editor.nix { inherit lib; })
        // (import ./settings/workbench.nix { inherit lib pkgs; })
        // (import ./settings/window.nix { inherit pkgs; })
        // (import ./settings/misc.nix { inherit lib pkgs; })
        // (import ./settings/lsp.nix { inherit lib pkgs; });
    in
    {
      enable = true;
      package = if isDarwin then vscodiumDummy else pkgs.vscodium;

      inherit
        extensions
        keybindings
        userSettings
        ;
    };
}
