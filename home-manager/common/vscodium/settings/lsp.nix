{
  lib,
  pkgs,
}:
{
  "black-formatter.path" = [ (lib.getExe pkgs.black) ];
  "stylua.styluaPath" = lib.getExe pkgs.stylua;
  "Lua.misc.executablePath" = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";
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
  "[lua]"."editor.defaultFormatter" = "JohnnyMorganz.stylua";
}
