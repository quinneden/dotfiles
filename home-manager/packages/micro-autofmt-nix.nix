{
  pkgs,
  fetchFromGitHub,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "micro-autofmt-nix";
  version = "2.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "quinneden";
    repo = "micro-autofmt";
    rev = "e075a9c2fea3ee2291e372a8d4b0c2f118ef9ade";
    sha256 = "sha256-/tTDAmGfU06WdMw3Z9IVevx4I47JSALY7JQiNqkbNUY=";
  };

  configurePhase = ''
    mkdir -p $out/micro-autofmt/help
    mkdir -p $out/syntax
  '';

  installPhase = ''
    cp $src/autofmt.lua $out/micro-autofmt/autofmt.lua
    cp $src/repo.json $out/micro-autofmt/repo.json
    cp $src/help/autofmt.md $out/micro-autofmt/help/autofmt.md
    cp $src/syntax/nix.yaml $out/syntax/nix.yaml
  '';
}
