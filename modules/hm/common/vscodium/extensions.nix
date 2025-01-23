{ inputs, pkgs }:
let
  # inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system})
    vscode-marketplace
    vscode-marketplace-release
    open-vsx
    ;

  # _3timeslazy.vscodium-devpodcontainers = buildVscodeMarketplaceExtension {
  #   mktplcRef = {
  #     name = "devpod-containers";
  #     publisher = "3timeslazy";
  #     version = "0.0.17";
  #   };
  #   vsix = builtins.fetchurl {
  #     url = "https://open-vsx.org/api/3timeslazy/vscodium-devpodcontainers/0.0.17/file/3timeslazy.vscodium-devpodcontainers-0.0.17.vsix";
  #     sha256 = "sha256-8I7Uocj4Aom+GgoMmqBNyA5wQUdF6EnS27BIuumemF8=";
  #   };
  #   dontUnpack = true;
  # };

  marketplace = with vscode-marketplace; [
    # bbenoist.nix
    hermitter.oh-lucy-vscode
    jnoortheen.nix-ide
    miguelsolorio.symbols
    ms-python.black-formatter
    ms-python.python
    shd101wyy.markdown-preview-enhanced
    timonwong.shellcheck
    tinkertrain.theme-panda
    vue.volar
    # ms-vscode-remote.remote-containers
  ];

  marketplace-release = with vscode-marketplace-release; [
    github.copilot
    github.copilot-chat
  ];

  openvsx =
    (with open-vsx; [
      jeanp413.open-remote-ssh
    ])
    ++ (with open-vsx."3timeslazy"; [ vscodium-devpodcontainers ]);
in
[ ] ++ marketplace ++ marketplace-release ++ openvsx
