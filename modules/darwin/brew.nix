{
  homebrew = {
    enable = true;
    caskArgs.language = "en-US.UTF-8";
    global.brewfile = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--quiet" ];
      upgrade = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
      "deskflow/homebrew-tap"
      "tinted-theming/tinted"
      "slp/krunkit"
      "slp/krun"
    ];

    casks = [
      "betterdisplay"
      "deskflow"
      "ghostty@tip"
      "iterm2"
      "macfuse"
      "pearcleaner"
      "podman-desktop"
      "utm"
      "vagrant"
      "vscodium"
    ];

    brews = [
      "act"
      "aria2"
      "awscli"
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
      "git-crypt"
      "git-lfs"
      "git"
      "glab"
      "glow"
      "gnu-sed"
      "gnupg"
      "go"
      "gobject-introspection"
      "gptfdisk"
      "gum"
      "ipython"
      "jq"
      "just"
      "krunvm"
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
      "pkg-config"
      "pnpm"
      "podman-compose"
      "podman-tui"
      "podman"
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
      "yazi"
      "yq"
      "zbar"
      "zlib"
    ];
  };
}
