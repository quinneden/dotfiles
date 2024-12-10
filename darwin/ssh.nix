{
  pkgs,
  secrets,
  ...
}:
{
  programs.ssh = {
    knownHosts = {
      picache = {
        hostNames = [
          "picache.qeden.me"
          "10.0.0.101"
        ];
        publicKey = "${secrets.pubkeys.picache}";
      };
    };
  };

  users.users.quinn.openssh.authorizedKeys = {
    keys = [
      "${secrets.pubkeys.picache}"
    ];
  };
}
