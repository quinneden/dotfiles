{
  lib,
  pkgs,
}:
{
  "black-formatter.path" = [ (lib.getExe pkgs.black) ];
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = lib.getExe pkgs.nil;
  "nix.formatterPath" = lib.getExe pkgs.nixfmt-rfc-style;
  "nix.serverSettings" = {
    "nil" = {
      "formatting" = {
        "command" = [ "nixfmt" ];
      };
      "diagnostics" = {
        "ignored" = [ "unused_binding" ];
      };
    };
  };
}
