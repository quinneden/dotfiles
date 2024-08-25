{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      jeff-hykin.better-nix-syntax
      kamadorueda.alejandra
    ];
    userSettings = {
      "alejandra.program" = "alejandra";
      "breadcrumbs.enabled" = true;
      # "catppuccin.accentColor" = "lavender";
      "editor.fontFamily" = "'Operator Mono Lig Book', 'SymbolsNerdFont'";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = false;
      "editor.minimap.enabled" = false;
      "editor.mouseWheelZoom" = false;
      "editor.renderControlCharacters" = false;
      "editor.scrollbar.horizontal" = "hidden";
      "editor.scrollbar.horizontalScrollbarSize" = 2;
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.verticalScrollbarSize" = 2;
      "explorer.confirmDragAndDrop" = false;
      "explorer.openEditors.visible" = 0;
      "extensions.autoUpdate" = false;
      "files.autoSave" = "off";
      "update.mode" = "none";
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.limit.value" = 10;
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.layoutControl.enabled" = false;
      "workbench.layoutControl.type" = "menu";
      "workbench.startupEditor" = "none";
      "workbench.statusBar.visible" = true;
      "window.customTitleBarVisibility" = "auto";
      "editor.tabSize" = 2;
      "terminal.integrated.fontFamily" = "'OperatorMono Nerd Font Mono','SymbolsNerdFont'";
      "terminal.integrated.fontSize" = "15";
      "terminal.integrated.fontWeight" = "300";
      "terminal.integrated.fontWeightBold" = "500";
      "terminal.integrated.defaultProfile.linux" = "zsh";
    };
    keybindings = [
      {
        key = "ctrl+/";
        command = "editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+s";
        command = "workbench.action.files.saveFiles";
      }
      {
        key = "meta+s";
        command = "workbench.action.files.saveFiles";
      }
      {
        key = "meta+shift+w";
        command = "workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
      }
      {
        key = "ctrl+w";
        command = "";
      }
      {
        key = "ctrl+d";
        command = "editor.action.duplicateSelection";
      }
      {
        key = "meta+shift+e";
        command = "workbench.view.explorer";
        when = "viewContainer.workbench.view.explorer.enabled";
      }
      {
        key = "meta+shift+f";
        command = "workbench.action.findInFiles";
      }
    ];
  };
}
