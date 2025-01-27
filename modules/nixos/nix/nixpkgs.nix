{ inputs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [
      inputs.nix-vscode-extensions.overlays.default
      inputs.nix-shell-scripts.overlays.default
      inputs.nur.overlays.default
    ];
  };
}
