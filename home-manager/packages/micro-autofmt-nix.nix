{
  pkgs,
  fetchFromGitHub,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "micro-autofmt-nix";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "quinneden";
    repo = "micro-autofmt";
    rev = "1147c5e47b10fd6d6ff44481ca77988a452e21d1";
    hash = "sha256-DikU2ju7gx71F4rSHT2ktCmvr8B07EuGKSZSSP143Ew=";
  };

  configurePhase = ''
    mkdir -p $out/help
    mkdir -p $out/syntax
  '';

  installPhase = ''
    cp $src/autofmt.lua $out/autofmt.lua
    cp $src/repo.json $out/repo.json
    cp $src/syntax/nix.yaml $out/syntax/nix.yaml
    cp $src/help/autofmt.md $out/help/autofmt.md
  '';
}
