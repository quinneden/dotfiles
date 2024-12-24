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
          "10.0.0.101"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGqlgWtG2A2o9qdw746Zt1n7tqd4Nm2qo17wzn3+JDa";
      };
    };
  };

  users.users.quinn.openssh.authorizedKeys = {
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGqlgWtG2A2o9qdw746Zt1n7tqd4Nm2qo17wzn3+JDa" # root@picache
    ];
  };
}
