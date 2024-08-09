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
    rev = "2c786b599da35e2c3897627a14e272d185587d28";
    hash = "sha256-ke3NjIjtwPTbSUjAWE7LmGh44LdT7TrIOGqxagDb0zI=";
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
