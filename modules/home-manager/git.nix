{
  pkgs,
  inputs,
  secrets,
  ...
}: {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "micro";
      credential.helper = "store";
      github.user = "quinneden";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      url = {
        "https://oauth2:${secrets.github.api}@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
    userEmail = "quinnyxboy@gmail.com";
    userName = "Quinn Edenfield";
  };
}
