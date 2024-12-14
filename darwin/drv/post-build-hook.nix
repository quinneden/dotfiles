{ lib, pkgs, ... }:
{
  picache-post-build-hook = pkgs.writeShellScript "picache-post-build-hook" ''
    set -euf
    if [[ -n "''${OUT_PATHS:-}" ]]; then
      export TS_MAXFINISHED=1000
      export TS_SLOTS=10
      printf "%s" "$OUT_PATHS" | xargs ${lib.getExe pkgs.ts} nix copy --to 'http://picache.qeden.me'
    fi
  '';
}
