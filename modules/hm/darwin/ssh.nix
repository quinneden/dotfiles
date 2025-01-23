{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    includes = [ "config.d/*.conf" ];
    matchBlocks = {
      "oc-runner" = {
        hostname = "129.146.66.178";
        user = "root";
        identityFile = "/Users/quinn/.ssh/keys/oc-runner_ssh_ed25519_key";
      };

      "picache" = {
        hostname = "10.0.0.101";
        user = "qeden";
        identityFile = "${../../../.secrets/keys/picache_ed25519}";
      };

      "macmini-m1".hostname = "10.0.0.235";
      "nixos-macmini".hostname = "10.0.0.243";
    };
  };
}
