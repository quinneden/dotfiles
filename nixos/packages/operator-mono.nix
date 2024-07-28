{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "operator-mono";
  version = "1.0";

  src = ../../assets/operator-mono.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';
}
