{ pkgs, ... }:
{
  homebrew = {
    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];
    casks = [
      "betterdisplay"
      # "docker"
      "eloston-chromium"
      "eqmac"
      "hammerspoon"
      "iterm2"
      "macfuse"
      "podman-desktop"
      "utm"
      "vagrant"
      # "vscodium"
      "wezterm"
    ];
    brews = [
      "act"
      "automake"
      "awscli"
      "sqlite"
      "aria2"
      "bat"
      "bison"
      "black"
      "bzip2"
      "cask"
      "chroma"
      "cmake"
      "curl"
      "cython"
      "docker"
      "eza"
      "fd"
      "flex"
      "fzf"
      "gcc"
      "gh"
      "git"
      "git-crypt"
      "git-lfs"
      "glab"
      "glow"
      "gnu-sed"
      "gnupg"
      "go"
      "gum"
      "pkg-config"
      "gobject-introspection"
      "gptfdisk"
      "ipython"
      "jq"
      "just"
      "ldid"
      "lf"
      "lftp"
      "libb2"
      "libffi"
      "libvirt"
      "lima"
      "llvm"
      "lzip"
      "lzo"
      "make"
      "mas"
      "meson"
      "micro"
      "ncdu"
      "node"
      "openssh"
      "openssl@3"
      "p7zip"
      "paperkey"
      "perl"
      "pipenv"
      "pipx"
      "podman"
      "pure"
      "pv"
      "pyenv-virtualenv"
      "pygments"
      "qemu"
      "qrencode"
      "rbenv"
      "rclone"
      "ripgrep"
      "rsync"
      "rust"
      "rustup"
      "shc"
      "shellcheck"
      "socket_vmnet"
      "tmux"
      "tree"
      "w3m"
      "wget"
      "magic-wormhole"
      "yapf"
      "yq"
      "zbar"
      "zlib"
    ];
    masApps = {
      "Adobe Lightroom" = 1451544217;
    };
  };
}
