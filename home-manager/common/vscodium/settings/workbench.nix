{ lib, pkgs }:
let
  inherit (pkgs.stdenv) isDarwin;
in
with lib;
{
  "workbench.activityBar.location" = "bottom";

  "workbench.colorTheme" = mkIf isDarwin "Panda Syntax";

  "workbench.editor.labelFormat" = "short";

  "workbench.iconTheme" = "symbols";

  "workbench.layoutControl.enabled" = true;

  "workbench.tree.indent" = 10;

  "workbench.view.showQuietly" = {
    "workbench.panel.output" = true;
  };

  "workbench.editor.closeOnFileDelete" = true;

  "workbench.editor.editorActionsLocation" = "titleBar";

  "workbench.settings.useSplitJSON" = true;

  "zenMode.hideLineNumbers" = false;

  "zenMode.restore" = false;

}
