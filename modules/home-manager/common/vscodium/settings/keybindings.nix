{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;

  intPairs = {
    "1" = "First";
    "2" = "Second";
    "3" = "Third";
    "4" = "Fourth";
    "5" = "Fifth";
    "6" = "Sixth";
    "7" = "Seventh";
    "8" = "Eighth";
    "9" = "Last";
  };
in
with lib;
[
  {
    command = "editor.action.commentLine";
    key = "ctrl+/";
    when = "editorTextFocus && !editorReadonly";
  }
  {
    command = "editor.action.blockComment";
    key = "ctrl+shift+/";
    when = "editorTextFocus && !editorReadonly";
  }
  {
    command = "workbench.action.files.saveFiles";
    key = "ctrl+s";
  }
  {
    command = "workbench.action.files.saveFiles";
    key = "meta+s";
  }
  {
    command = "undo";
    key = "ctrl+z";
  }
  {
    command = "workbench.action.terminal.toggleTerminal";
    key = "meta+shift+w";
    when = "terminal.active";
  }
  (mkIf isDarwin {
    command = "";
    key = "ctrl+w";
  })
  {
    command = "editor.action.duplicateSelection";
    key = "ctrl+d";
  }
  {
    command = "editor.action.duplicateSelection";
    key = "meta+d";
  }
  {
    command = "workbench.view.explorer";
    key = "meta+shift+e";
    when = "viewContainer.workbench.view.explorer.enabled";
  }
  {
    command = "workbench.action.findInFiles";
    key = "meta+shift+f";
  }
  {
    command = "workbench.action.focusPreviousGroup";
    key = "meta+left";
  }
  {
    command = "workbench.action.focusNextGroup";
    key = "meta+right";
  }
  {
    command = "copilot-chat.focus";
    key = "ctrl+shift+i";
  }
  {
    command = "explorer.newFile";
    key = "meta+n";
    when = "explorerViewletFocus";
  }
  {
    command = "explorer.newFolder";
    key = "meta+shift+n";
    when = "explorerViewletFocus";
  }
]
++ map (n: {
  key = "meta+${toString n}";
  command = "workbench.action.openEditorAtIndex${toString n}";
}) (range 1 9 ++ [ 0 ])
++ mapAttrsToList (n: o: {
  key = "ctrl+${n}";
  command = "workbench.action.focus${o}EditorGroup";
}) intPairs
