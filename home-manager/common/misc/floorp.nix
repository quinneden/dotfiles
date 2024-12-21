{
  pkgs,
  inputs,
  ...
}:
let
  extra-addons =
    let
      buildFirefoxXpiAddon =
        {
          src,
          pname,
          version,
          addonId,
        }:
        pkgs.stdenv.mkDerivation {
          name = "${pname}-${version}";
          inherit src;
          preferLocalBuild = true;
          allowSubstitutes = true;
          buildCommand = ''
            dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
            mkdir -p "$dst"
            install -v -m644 "$src" "$dst/${addonId}.xpi"
          '';
        };
      remoteXpiAddon =
        {
          pname,
          version,
          addonId,
          url,
          sha256,
        }:
        buildFirefoxXpiAddon {
          inherit pname version addonId;
          src = pkgs.fetchurl { inherit url sha256; };
        };
    in
    {
      catppuccin-frappe-sky = remoteXpiAddon {
        pname = "catppuccin-frappe-sky";
        version = "unknown";
        addonId = "{c7cf6786-24b7-4bd2-ae71-b985fcc98f20}";
        url = "https://github.com/catppuccin/firefox/releases/download/old/catppuccin_frappe_sky.xpi";
        sha256 = "sha256-Fb9VUpsWKtERV4VkeWhBZBSZLMkQMrnBexaRIuPc4Ho=";
      };
      google-container = remoteXpiAddon {
        pname = "Google Container";
        version = "1.5.4";
        addonId = "@contain-google";
        url = "https://addons.mozilla.org/firefox/downloads/file/3736912/google_container-1.5.4.xpi";
        sha256 = "sha256-R6fA6FRoMyoNlJko2LdDdhks3kq6oUKAACs6yk7IFNA=";
      };
    };
in
{
  programs = {
    floorp = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then pkgs.floorp-unwrapped else pkgs.floorp;
      profiles = {
        "freeform" = {
          isDefault = true;
          search = {
            force = true;
            default = "Google";
            privateDefault = "Google";
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
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
              "NixOS Wiki" = {
                urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                definedAliases = [ "@nw" ];
              };
              "NixOS Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
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
              "Brave" = {
                urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
                iconUpdateURL = "https://upload.wikimedia.org/wikipedia/commons/5/51/Brave_icon_lionface.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [ "@b" ];
              };
              "Github Code" = {
                urls = [ { template = "https://github.com/search?q={searchTerms}&type=code"; } ];
                definedAliases = [
                  "@ghc"
                  "@gc"
                ];
                iconUpdateURL = "https://upload.wikimedia.org/wikipedia/commons/9/91/Octicons-mark-github.svg";
                updateInterval = 24 * 60 * 1000;
              };
              "Github Repos" = {
                urls = [
                  { template = "https://github.com/{searchTerms}"; }
                  { template = "https://github.com/search?q={searchTerms}&type=repositories"; }
                ];
                definedAliases = [
                  "@ghr"
                  "@repo"
                ];
                iconUpdateURL = "https://upload.wikimedia.org/wikipedia/commons/9/91/Octicons-mark-github.svg";
                updateInterval = 24 * 60 * 1000;
              };
              "Bing".metaData.hidden = true;
              "Startpage".metaData.hidden = true;
              # "Google".metaData = {
              #   hidden = true;
              # };
              "DuckDuckGo".metaData = {
                hidden = true;
              };
            };
            order = [
              "Brave"
              "Nix Packages"
              "Nix Options"
              "NixOS Wiki"
            ];
          };
          extensions =
            with inputs.firefox-addons.packages.${pkgs.system};
            with extra-addons;
            [
              ublock-origin
              darkreader
              firefox-color
              terms-of-service-didnt-read
              stylus
              decentraleyes
              clearurls
              google-container
              catppuccin-frappe-sky
            ];
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.aboutConfig.showWarning" = false;
            "browser.startup.page" = 0;
            "browser.preferences.experimental" = true;
            "browser.startup.homepage" = "about:home";
            "browser.newtabpage.enabled" = true;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;
            "extensions.unifiedExtensions.enabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";
            "browser.ping-centre.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "captivedetect.canonicalURL" = "";
            "network.captive-portal-service.enabled" = false;
            "network.connectivity-service.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "browser.safebrowsing.downloads.remote.url" = "";
            "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
            "browser.safebrowsing.downloads.remote.block_uncommon" = false;
            "browser.safebrowsing.allowOverride" = false;
            "privacy.resistFingerprinting.block_mozAddonManager" = true;
            "signon.rememberSignons" = true;
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "extensions.pocket.enabled" = false;
            "browser.newtabpage.activity-stream.topSitesRows" = 2;
            "general.smoothScroll" = true;
            "general.autoScroll" = true;
            "sidebar.enable" = false;
            "browser.newtabpage.activity-stream.showRecentSaves" = false;
            "browser.taskbar.lists.enabled" = false;
            "browser.taskbar.lists.frequent.enabled" = false;
            "browser.taskbar.lists.tasks.enabled" = false;
            "browser.newtabpage.activity-stream.enabled" = false;
            "browser.newtabpage.pinned" = [
              {
                label = "Github";
                url = "https://github.com";
              }
            ];
          };
          bookmarks = [
            {
              name = "Hosted";
              bookmarks = [
                {
                  name = "Cloudflare";
                  url = "https://dash.cloudflare.com";
                }
              ];
            }
            {
              name = "Nix";
              bookmarks = [
                {
                  name = "NixOS Wiki";
                  url = "https://nixos.wiki/wiki/";
                }
                {
                  name = "HM Options";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
                }
                {
                  name = "nixpkgs";
                  url = "https://github.com/NixOS/nixpkgs/";
                }
                {
                  name = "PR Tracker";
                  url = "https://nixpk.gs/pr-tracker.html";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
