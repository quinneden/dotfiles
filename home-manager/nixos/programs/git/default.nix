{ config, secrets, ... }:
let
  username = config.var.git.username;
  email = config.var.git.email;
in
{
  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "*.elc"
      "auto-save-list"
      ".direnv/"
      "node_modules"
      "result"
      "result-*"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      color.ui = "1";
      url."https://oauth2:${secrets.github.token}@github.com".insteadOf = "https://github.com";
      github.user = username;
    };
    aliases = {
      br = "branch";
      df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
      hist = ''log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
      llog = ''log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
      edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
    };
  };
}
