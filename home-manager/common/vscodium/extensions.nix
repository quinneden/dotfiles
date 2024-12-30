{ inputs, pkgs }:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system})
    vscode-marketplace
    vscode-marketplace-release
    open-vsx
    ;

  devpod-containers = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "devpod-containers";
      publisher = "3timeslazy";
      version = "0.0.17";
    };
    vsix = builtins.fetchurl {
      url = "https://open-vsx.org/api/3timeslazy/vscodium-devpodcontainers/0.0.17/file/3timeslazy.vscodium-devpodcontainers-0.0.17.vsix";
      sha256 = "sha256-8I7Uocj4Aom+GgoMmqBNyA5wQUdF6EnS27BIuumemF8=";
    };
    dontUnpack = true;
  };

  normal = with pkgs.vscode-extensions; [
    bbenoist.nix
    dracula-theme.theme-dracula
  ];

  marketplace = with vscode-marketplace; [
    ms-python.python
    ms-python.black-formatter
    jnoortheen.nix-ide
    miguelsolorio.symbols
    devpod-containers
    lancewilhelm.horizon-extended
    hermitter.oh-lucy-vscode
  ];

  marketplace-release = with vscode-marketplace-release; [
    github.copilot
    github.copilot-chat
  ];

  openvsx = with open-vsx; [
    pr1sm8.theme-panda
    jeanp413.open-remote-ssh
  ];
in
[ ] ++ normal ++ marketplace ++ marketplace-release ++ openvsx
