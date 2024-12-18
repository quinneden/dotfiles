{ pkgs, ... }:
{
  homebrew = {
    taps = [
      "homebrew/bundle"
      "homebrew/services"
      "deskflow/homebrew-tap"
    ];
    casks = [
      "betterdisplay"
      "deskflow"
      "eloston-chromium"
      "eqmac"
      "iterm2"
      "macfuse"
      "utm"
      "vagrant"
      "pearcleaner"
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
      "openssl@3"
      "p7zip"
      "paperkey"
      "perl"
      "pipenv"
      "pipx"
      "podman"
      "pure"
      "pv"
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
      "tree"
      "w3m"
      "wget"
      "magic-wormhole"
      "yarn"
      "yq"
      "zbar"
      "zlib"
    ];
    # masApps = {
    #   "Adobe Lightroom" = 1451544217;
    # };
  };
}
