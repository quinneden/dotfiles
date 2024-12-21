{
  inputs,
  pkgs,
}:
let
  devpod-containers = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "devpod-containers";
      version = "0.0.17";
      publisher = "3timeslazy";
    };
    vsix = builtins.fetchurl {
      url = "https://open-vsx.org/api/3timeslazy/vscodium-devpodcontainers/0.0.17/file/3timeslazy.vscodium-devpodcontainers-0.0.17.vsix";
      sha256 = "sha256-8I7Uocj4Aom+GgoMmqBNyA5wQUdF6EnS27BIuumemF8=";
    };

    dontUnpack = true;
  };

  normal = with pkgs.vscode-extensions; [
    bbenoist.nix
    sumneko.lua
    xaver.clang-format
    ziglang.vscode-zig
    devpod-containers
  ];

  marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
  open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
  release = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace-release;

  community =
    (with marketplace; [
      ms-python.python
      ms-python.black-formatter
      johnnymorganz.stylua
      rvest.vs-code-prettier-eslint
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
      miguelsolorio.symbols
    ])
    ++ (with release; [
      github.copilot
      github.copilot-chat
    ])
    ++ (with open-vsx; [
      pr1sm8.theme-panda
      jeanp413.open-remote-ssh
    ]);
in
[ ] ++ normal ++ community
