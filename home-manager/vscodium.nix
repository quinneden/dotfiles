{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      arrterian.nix-env-selector
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];
    # userSettings = {
    #   "breadcrumbs.enabled" = true;
    #   "catppuccin.accentColor" = "lavender";
    #   "editor.fontFamily" = "'Caskaydia Mono Nerd Font', 'SymbolsNerdFont'";
    #   "editor.fontLigatures" = true;
    #   "editor.fontSize" = 14;
    #   "editor.formatOnPaste" = true;
    #   "editor.formatOnSave" = true;
    #   "editor.formatOnType" = false;
    #   "editor.minimap.enabled" = false;
    #   "editor.mouseWheelZoom" = false;
    #   "editor.renderControlCharacters" = false;
    #   "editor.scrollbar.horizontal" = "hidden";
    #   "editor.scrollbar.horizontalScrollbarSize" = 2;
    #   "editor.scrollbar.vertical" = "hidden";
    #   "editor.scrollbar.verticalScrollbarSize" = 2;
    #   "explorer.confirmDragAndDrop" = false;
    #   "explorer.openEditors.visible" = 0;
    #   "extensions.autoUpdate" = false; # This stuff fixes vscode freaking out when theres an update
    #   "files.autoSave" = "onWindowChange";
    #   "terminal.integrated.fontFamily" = "'Caskaydia Mono Nerd Font', 'SymbolsNerdFont'";
    #   "update.mode" = "none";
    #   "vsicons.dontShowNewVersionMessage" = true;
    #   "window.menuBarVisibility" = "hidden";
    #   "window.titleBarStyle" = "custom"; # needed otherwise vscode crashes, see https://github.com/NixOS/nixpkgs/issues/246509
    #   "workbench.activityBar.location" = "bottom";
    #   "workbench.colorTheme" = "Catppuccin Mocha";
    #   "workbench.editor.limit.enabled" = true;
    #   "workbench.editor.limit.perEditorGroup" = true;
    #   "workbench.editor.limit.value" = 10;
    #   "workbench.iconTheme" = "catppuccin-mocha";
    #   "workbench.layoutControl.enabled" = false;
    #   "workbench.layoutControl.type" = "menu";
    #   "workbench.startupEditor" = "none";
    #   "workbench.statusBar.visible" = true;
    # };
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
