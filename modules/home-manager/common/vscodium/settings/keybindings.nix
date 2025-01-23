{ lib, ... }:
let
  inherit (builtins) elemAt;

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
  {
    command = "";
    key = "ctrl+w";
  }
  {
    command = "editor.action.duplicateSelection";
    key = "ctrl+d";
  }
  {
    command = "editor.action.duplicateSelection";
    key = "cmd+d";
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
    key = "cmd+left";
  }
  {
    command = "workbench.action.focusNextGroup";
    key = "cmd+right";
  }
  {
    command = "copilot-chat.focus";
    key = "ctrl+shift+i";
  }
  {
    "key" = "cmd+n";
    "command" = "explorer.newFile";
    "when" = "explorerViewletFocus";
  }
  {
    "key" = "cmd+shift+n";
    "command" = "explorer.newFolder";
    "when" = "explorerViewletFocus";
  }
  {
    "key" = "cmd+ctrl+p";
    "command" = "workbench.action.tasks.runTask";
    "args" = "Simple Browser";
  }
]
++ map (n: {
  key = "cmd+${toString n}";
  command = "workbench.action.openEditorAtIndex${toString n}";
}) (lib.range 1 9 ++ [ 0 ])
++ lib.mapAttrsToList (n: o: {
  key = "ctrl+${n}";
  command = "workbench.action.focus${o}EditorGroup";
}) intPairs
