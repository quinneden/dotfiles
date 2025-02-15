{
  buffer_font_family = "CaskaydiaCoveNFM-SemiLight";
  confirm_quit = true;
  diagnostics = false;

  features = {
    inline_completion_provider = "copilot";
  };

  indent_guides = {
    enabled = true;
    line_width = 1;
    active_line_width = 1;
    coloring = "fixed";
    background_coloring = "disabled";
  };

  load_direnv = "direct";

  lsp = {
    nil = {
      initialization_options = {
        formatting = {
          command = [
            "nixfmt"
            "-q"
            "--"
          ];
        };
      };

      settings = {
        nix = {
          flake = {
            autoArchive = true;
          };
        };
      };
    };
  };

  metrics = false;

  preview_tabs = {
    enabled = true;
    enable_preview_from_file_finder = false;
    enable_preview_from_code_navigation = false;
  };

  project_panel = {
    button = true;
    default_width = 240;
    dock = "left";
    entry_spacing = "comfortable";
    file_icons = true;
    folder_icons = true;
    git_status = true;

    indent_size = 20;
    indent_guides = {
      show = "always";
    };

    auto_reveal_entries = true;
    auto_fold_dirs = true;

    scrollbar = {
      show = false;
    };
  };

  tab_size = 2;
  tabs = {
    close_position = "right";
    file_icons = false;
    git_status = false;
    activate_on_close = "history";
    always_show_close_button = false;
  };

  terminal = {
    alternate_scroll = "off";
    blinking = "terminal_controlled";
    copy_on_select = false;
    dock = "bottom";
    detect_venv = {
      on = {
        directories = [
          ".env"
          "env"
          ".venv"
          "venv"
        ];
        activate_script = "default";
      };
    };

    env = { };

    font_family = "CaskaydiaCoveNFM-SemiLight";
    font_size = 14;

    line_height = "comfortable";

    toolbar = {
      breadcrumbs = false;
    };

    scrollbar = {
      show = false;
    };

    theme = {
      mode = "dark";
      dark = "oh-lucy";
    };
  };
}
