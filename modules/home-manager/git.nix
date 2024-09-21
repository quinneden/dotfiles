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
      alias.commit-status = ''
        TMPFILE=$(mktemp /tmp/git-commit-status-message.XXX); \
    		git status --porcelain \
    		  | grep '^[MARCDT]' \
    		  | sort \
    		  | sed -re 's/^([[:upper:]])[[:upper:]]?[[:space:]]+/\\1:\\n/' \
    		  | awk '!x[$0]++' \
    		  | sed -re 's/^([[:upper:]]:)$/\\n\\1/' \
    		  | sed -re 's/^M:$/Modified: /' \
    		  | sed -re 's/^A:$/Added: /' \
    		  | sed -re 's/^R:$/Renamed: /' \
    		  | sed -re 's/^C:$/Copied: /' \
    		  | sed -re 's/^D:$/Deleted: /' \
    		  | sed -re 's/^T:$/File Type Changed: /' \
    		  | tr '\n' ' ' | xargs \
    		  > $TMPFILE; \
    		cat $TMPFILE; \
    	        commit=\'\'; \
    	        while :; do \
    			echo '> Commit with this message? [Yn]: '; \
    			read commit; \
    			([ -z \"$commit\" ] || [ \"$commit\" = y ] || [ \"$commit\" = Y ] || [ \"$commit\" = n ]) && break; \
    	        done; \
    		test \"$commit\" != n || exit; \
    		git commit -F $TMPFILE; \
    		rm -f $TMPFILE \
      '';
    };
    userEmail = "quinnyxboy@gmail.com";
    userName = "Quinn Edenfield";
  };
}
