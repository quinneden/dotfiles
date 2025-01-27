{ secrets, ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "micro";
      credential.helper = "store";
      github.user = "quinneden";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      url."https://oauth2:${secrets.github.token}@github.com".insteadOf = "https://github.com";
    };
    userEmail = "quinnyxboy@gmail.com";
    userName = "Quinn Edenfield";
  };
}
