{
  lib,
  fetchurl,
  stdenv,
  unzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tabby-release";
  version = "1.0.215";

  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v1.0.215/tabby-1.0.215-macos-arm64.zip";
    sha256 = "sha256-1yXT8XI+UVU5LY8/ziICfojlEf5QdEWPMKcSEMXl0qE=";
  };

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/Applications
    unzip $src -d $out/Applications
    runHook postBuild
  '';
})
