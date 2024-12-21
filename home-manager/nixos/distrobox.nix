{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ./modules/distrobox.nix ];

  programs.distrobox = {
    enable = true;

    boxes =
      let
        exec = "${lib.getExe pkgs.zsh}";
        symlinks = [
          ".bashrc"
          ".zshenv"
          ".config/nix"
          ".config/starship.toml"
          "/etc/profiles/per-user/quinn/bin/starship"
        ];
        packages =
          config.packages.cli
          ++ (with pkgs; [
            nix
            mi
            fuck
          ]);
      in
      {
        Fedora = {
          inherit exec symlinks;
          packages = "nodejs npm poetry clang gcc python3 wl-clipboard rustup llvm p7zip p7zip-plugins";
          img = "registry.fedoraproject.org/fedora-toolbox:rawhide";
          nixPackages = packages ++ [
            (pkgs.writeShellScriptBin "pr" "poetry run $@")
            (pkgs.writeShellScriptBin "prpm" "poetry run python manage.py $@")
          ];
        };
        Arch = {
          inherit exec symlinks;
          img = "docker.io/library/archlinux:latest";
          packages = "base-devel wl-clipboard";
          nixPackages = packages ++ [
            (pkgs.writeShellScriptBin "yay" ''
              if [[ ! -f /bin/yay ]]; then
                tmpdir="$HOME/.yay-bin"
                if [[ -d "$tmpdir" ]]; then sudo rm -r "$tmpdir"; fi
                git clone https://aur.archlinux.org/yay-bin.git "$tmpdir"
                cd "$tmpdir"
                makepkg -si
                sudo rm -r "$tmpdir"
              fi
              /bin/yay $@
            '')
          ];
        };
      };
  };
}
