{ pkgs, ... }:

{
  "window.commandCenter" = true;

  "window.customMenuBarAltFocus" = false;

  "window.menuBarVisibility" = "compact";

  "window.restoreFullscreen" = true;

  "window.titleBarStyle" = "custom";

  "window.zoomLevel" = if pkgs.stdenv.isDarwin then 0.3 else 0.4;

  "workbench.view.showQuietly" = {
    "workbench.panel.output" = true;
  };

  "workbench.editor.closeOnFileDelete" = true;

  "workbench.editor.editorActionsLocation" = "titleBar";

  "workbench.settings.useSplitJSON" = true;

  "zenMode.hideLineNumbers" = false;

  "zenMode.restore" = false;
}
