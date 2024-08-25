{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "micro";
      credential.helper = "store";
      github.user = "quinneden";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
    userEmail = "quinnyxboy@gmail.com";
    userName = "Quinn Edenfield";
  };
}
