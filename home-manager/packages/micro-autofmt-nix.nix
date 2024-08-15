{
  pkgs,
  fetchFromGitHub,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "micro-autofmt-nix";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "quinneden";
    repo = "micro-autofmt";
    rev = "main";
    hash = "sha256-h5+vtPK19mtYyV3voMdhL/5XFlrgCOxPnZjwUTK+3g0=";
  };

  configurePhase = ''
    mkdir -p $out/help
  '';

  installPhase = ''
    cp $src/autofmt.lua $out/autofmt.lua
    cp $src/repo.json $out/repo.json
    cp $src/help/autofmt.md $out/help/autofmt.md
  '';
}
