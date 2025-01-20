{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    caskArgs.language = "en-US.UTF-8";
    global.brewfile = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
      extraFlags = [ "--quiet" ];
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
      "deskflow/homebrew-tap"
      "tinted-theming/tinted"
      "slp/krun"
    ];

    casks = [
      "betterdisplay"
      "deskflow"
      "devpod"
      "ghostty"
      "iterm2"
      "macfuse"
      "utm"
      "vagrant"
      "vscodium"
      "pearcleaner"
      "podman-desktop"
    ];

    brews = [
      "act"
      "awscli"
      "aria2"
      "bat"
      "black"
      "bzip2"
      "chroma"
      "cmake"
      "coreutils"
      "curl"
      "eza"
      "fd"
      "ffmpeg"
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
      "krunvm"
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
      "most"
      "ncdu"
      "node"
      "oci-cli"
      "openssl@3"
      "p7zip"
      "perl"
      "pipenv"
      "pipx"
      "pnpm"
      "podman"
      "podman-tui"
      "podman-compose"
      "pure"
      "pv"
      "qemu"
      "rclone"
      "ripgrep"
      "rsync"
      "rustup"
      "shc"
      "shellcheck"
      "tinty"
      "tree"
      "vercel-cli"
      "w3m"
      "wget"
      "yq"
      "zbar"
      "zlib"
    ];
  };
}
