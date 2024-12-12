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
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4ICmIWbhYqbTKTZ2qA+w33mu61RA3PTJ8q1c7R6hJl";
      };
    };
  };

  users.users.quinn.openssh.authorizedKeys = {
    keys = [
      "${secrets.pubkeys.picache}"
    ];
  };
}
