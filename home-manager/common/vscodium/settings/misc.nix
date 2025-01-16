{ pkgs, ... }:
let
  github-dark-css = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/sindresorhus/github-markdown-css/refs/heads/main/github-markdown-dark.css";
    hash = "sha256-oUe3spdT73jIB9O3kh3i65+RZcWbFts4SCNqVZn1Dxs=";
  };
in
{
  "extensions.ignoreRecommendations" = true;

  "breadcrums.enabled" = false;

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

  "markdown.preview.fontSize" = 14;

  "markdown-preview-enhanced.automaticallyShowPreviewOfMarkdownBeingEdited" = true;
  "markdown-preview-enhanced.previewTheme" = "github-dark.css";
  "markdown-preview-enhanced.codeBlockTheme" = "github-dark.css";
}
