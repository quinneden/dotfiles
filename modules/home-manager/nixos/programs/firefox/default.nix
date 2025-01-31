# Not using this file anymore, but keeping it for reference
{
  pkgs,
  config,
  ...
}:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  foreground = "#${config.lib.stylix.colors.base05}";
  muted = "#${config.lib.stylix.colors.base03}";

  settings = ''
    {
      "config": {
        "title" : "Welcome Home",
        "openLinksInNewTab": false,
        "locale": "en-US",
        "colors": {
          "primary": "${accent}",
          "background": "${background}",
          "foreground": "${foreground}",
          "muted": "#${muted}"
        },
        "folders": [
          {
            "name": "Bookmarks",
            "links": [
              {"title": "Github", "url": "https://github.com", "icon": ""},
              {"title": "Cloudflare", "url": "https://dash.cloudflare.com/", "icon": ""},
              {"title": "ChatGPT", "url": "https://chatgpt.com/", "icon": "󰭹"},
              {"title": "NixOS Options", "url": "https://search.nixos.org/options?channel=unstable", "icon": ""},
              {"title": "NixOS Packages", "url": "https://search.nixos.org/packages?channel=unstable", "icon": ""},
            ]
          }
        ]
      }
    }
  '';
in
# homepage = pkgs.buildNpmPackage {
#   pname = "homepage";
#   version = "0.0.0";
#   src = pkgs.fetchFromGitHub {
#     owner = "anotherhadi";
#     repo = "homepage";
#     rev = "b77d35ed3596eb451bd2ec78063d7cc6e73c773d";
#     hash = "sha256-j/40922kfAh6zqJ4IRYpr66YXNNYsxuXwZ0aiJFJea0=";
#   };
#   # npmDepsHash = lib.fakeHash;
#   npmDepsHash = "sha256-bG+CHTq2Rst3JMxsjAC81KhK+G7WwsTVD1eyP87g0z4=";
#   buildPhase = ''
#     npm install
#     cp ${pkgs.writeText "src/routes/config.json" settings} src/routes/config.json
#     npm run build
#     mkdir $out
#     mv build $out
#   '';
#   meta = {
#     description = "homepage";
#     homepage = "https://github.com/anotherhadi/homepage";
#   };
# };
{
  # home.file."homepage" = {
  #   source = "${homepage}/build";
  #   recursive = true;
  # };

  stylix.targets.firefox.profileNames = [ "default" ];
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      Preferences = {
        "extensions.autoDisableScopes" = 0; # Automatically enable extensions
        "extensions.update.enabled" = false;
      };
    };

    profiles."default" = {
      id = 0;
      isDefault = true;
      name = "default";
      settings = {
        "app.normandy.first_run" = false;
        "browser.uidensity" = 1;
        "bookmarks.restore_default_bookmarks" = false;

        "browser.bookmarks.addedImportButton" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.warnOnQuitShortcut" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "signon.rememberSignons" = false;

        "browser.startup.homepage" = "t.qeden.me";
        "browser.search.region" = "US";
        "distribution.searchplugins.defaultLocale" = "en-US";
        "general.useragent.locale" = "en-US";
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.newtabpage.pinned" = [
          {
            title = "Homepage";
            url = "t.qeden.me";
          }
        ];

        services.sync.engine.addons = false;
        services.sync.nextSync = 0;

        signon.firefoxRelay.feature = "disabled";
        signon.generation.enabled = "false";
      };
      bookmarks = [
        {
          name = "Homepage";
          url = "t.qeden.me";
        }
      ];
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
        ublock-origin
        # vimium
        sponsorblock
        darkreader
        youtube-recommended-videos
      ];
      search = {
        order = [ "google" ];
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Options" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          "NixOS Wiki" = {
            urls = [
              {
                template = "https://wiki.nixos.org/index.php?search={searchTerms}";
              }
            ];
            iconUpdateURL = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
        default = "Google";
      };

      userChrome = ''
          /* Base color for the theme, dependent on whether it's a light theme or not */
          @media (prefers-color-scheme: dark) {
            :root {
              --accent-color: #11111b;
            }
          }

          @media (prefers-color-scheme: light) {
            :root {
              --accent-color: #dce0e8;
            }
          }

          /*====== Aesthetics ======*/

          #navigator-toolbox {
            border-bottom: none !important;
          }

          #titlebar {
            background: var(--accent-color) !important;
          }

          /* Sets the toolbar color */
          toolbar#nav-bar {
            background: var(--accent-color) !important;
            box-shadow: none !important;
          }

          /* Sets the URL bar color */
          #urlbar {
            background: var(--accent-color) !important;
          }

          #urlbar-background {
            background: var(--accent-color) !important;
            border: none !important;
          }

          #urlbar-input-container {
            border: none !important;
          }

          /*====== UI Settings ======*/

          :root {
            --navbarWidth: 500px;
            /* Set width of navbar */
          }

          /* If the window is wider than 1000px, use flex layout */
          @media (min-width: 1000px) {
            #navigator-toolbox {
              display: flex;
              flex-direction: row;
              flex-wrap: wrap;
            }

            /*  Url bar  */
            #nav-bar {
              order: 2;
              width: var(--navbarWidth);
            }

            /* Tab bar */
            #titlebar {
              order: 1;
              width: calc(100vw - var(--navbarWidth) - 1px);
            }

            /* Bookmarks bar */
            #PersonalToolbar {
              order: 3;
              width: 100%;
            }

            /* Fix urlbar sometimes being misaligned */
            :root[uidensity="compact"] #urlbar {
              --urlbar-toolbar-height: 39.60px !important;
            }

            :root[uidensity="touch"] #urlbar {
              --urlbar-toolbar-height: 49.00px !important;
            }
          }

          /*====== Simplifying interface ======*/

          /* Autohide back button when disabled */
          #back-button,
          #forward-button,
          /* Remove UI elements */
          #identity-box,
          /* Site information */
          #tracking-protection-icon-container,
          /* Shield icon */
          #page-action-buttons> :not(#urlbar-zoom-button, #star-button-box),
          /* All url bar icons except for zoom level and bookmarks */
          #urlbar-go-button,
          /* Search URL magnifying glass */
          #alltabs-button,
          /* Menu to display all tabs at the end of tabs bar */
          .titlebar-buttonbox-container

          /* Minimize, maximize, and close buttons */
            {
            display: none !important;
          }

          #nav-bar {
            box-shadow: none !important;
          }

          /* Remove "padding" left and right from tabs */
          .titlebar-spacer {
            display: none !important;
          }

          /* Fix URL bar overlapping elements */
          #urlbar-container {
            min-width: none !important;
          }

          /* Remove gap after pinned tabs */
          #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])>#tabbrowser-arrowscrollbox>.tabbrowser-tab[first-visible-unpinned-tab] {
            margin-inline-start: 0 !important;
          }

          /* Hide the hamburger menu */
          #PanelUI-menu-button {
            padding: 0px !important;
          }

          #PanelUI-menu-button .toolbarbutton-icon {
            width: 0px !important;
          }

          #PanelUI-menu-button .toolbarbutton-badge-stack {
            padding: 0px !important;
        }'';
    };
    # profiles = {
    # default = {
    #   extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #     ublock-origin
    #     vimium
    #     sponsorblock
    #     youtube-recommended-videos
    #     scroll_anywhere
    #     newtab-adapter
    #     plasma-integration
    #   ];
    # };
  };
}
