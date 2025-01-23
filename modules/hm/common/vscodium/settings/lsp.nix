{
  lib,
  pkgs,
}:
with lib;
{
  "black-formatter.path" = [ (getExe pkgs.black) ];

  "nix.enableLanguageServer" = true;

  "nix.serverPath" = getExe pkgs.nil;

  "nix.formatterPath" = getExe pkgs.nixfmt-rfc-style;

  "nix.serverSettings" = {
    "nil" = {
      "formatting" = {
        "command" = [ "nixfmt" ];
      };
      # "diagnostics" = {
      #   "ignored" = [ "unused_binding" ];
      # };
    };
  };
}
