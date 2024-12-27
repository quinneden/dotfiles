{
  inputs,
  pkgs,
}:
let
  devpod-containers = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
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
  ];

  marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;

  marketplace-release =
    inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace-release;

  open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;

  community =
    (with marketplace; [
      ms-python.python
      ms-python.black-formatter
      jnoortheen.nix-ide
      miguelsolorio.symbols
      devpod-containers
      obstinate.vesper-pp
    ])
    ++ (with marketplace-release; [
      github.copilot
      github.copilot-chat
    ])
    ++ (with open-vsx; [
      pr1sm8.theme-panda
      jeanp413.open-remote-ssh
    ]);
in
[ ] ++ normal ++ community
