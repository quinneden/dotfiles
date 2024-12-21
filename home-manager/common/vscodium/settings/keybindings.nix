let
  keybindings =
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
        key = "alt+left";
      }
      {
        command = "workbench.action.focusNextGroup";
        key = "alt+right";
      }
      {
        command = "copilot-chat.focus";
        key = "ctrl+shift+i";
      }
      {
        command = "workbench.action.focusFirstEditorGroup";
        key = "ctrl+1";
      }
      {
        command = "workbench.action.focusSecondEditorGroup";
        key = "ctrl+2";
      }
      {
        command = "workbench.action.focusThirdEditorGroup";
        key = "ctrl+3";
      }
      {
        command = "workbench.action.focusFourthEditorGroup";
        key = "ctrl+4";
      }
      {
        command = "workbench.action.focusFifthEditorGroup";
        key = "ctrl+5";
      }
      {
        command = "workbench.action.focusSixthEditorGroup";
        key = "ctrl+6";
      }
      {
        command = "workbench.action.focusSeventhEditorGroup";
        key = "ctrl+7";
      }
      {
        command = "workbench.action.focusEighthEditorGroup";
        key = "ctrl+8";
      }
      {
        command = "workbench.action.focusLastEditorGroup";
        key = "ctrl+9";
      }
    ]
    ++ map
      (n: {
        key = "cmd+${toString n}";
        command = "workbench.action.openEditorAtIndex${toString n}";
      })
      [
        1
        2
        3
        4
        5
        6
        7
        8
        9
      ];

in
[ ] ++ keybindings
