{
  lib,
  pkgs,
  ...
}:
{
  "extensions.ignoreRecommendations" = true;

  "breadcrums.enabled" = false;

  "chat.commandCenter.enabled" = false;

  "explorer.compactFolders" = false;

  "explorer.fileNesting.enabled" = false;

  "github.copilot.enable" = {
    "*" = true;
    "plaintext" = false;
    "markdown" = true;
    "scminput" = false;
  };

  "github.copilot.advanced" = {
    "useLanguageServer" = true;
  };

  "git.openRepositoryInParentFolders" = "always";

  "markdown.preview.fontSize" = lib.mkForce 14;

  "markdown-preview-enhanced.automaticallyShowPreviewOfMarkdownBeingEdited" = true;
  "markdown-preview-enhanced.previewTheme" = "github-dark.css";
  "markdown-preview-enhanced.codeBlockTheme" = "github-dark.css";
}
