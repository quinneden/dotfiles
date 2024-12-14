{
  home.file.".ssh/config.d/100-picache.conf".text = ''
    Host picache
      User qeden
      Hostname 10.0.0.101
      PasswordAuthentication no
      IdentityFile ${../../.secrets/keys/picache_ed25519}
  '';
}
