{
  pkgs,
  inputs,
  system,
  ...
}:
let
  patchForVagrant = pkgs.writeText "vagrant-bump-rexml-to-3_3.patch" ''
    diff --git a/vagrant_cloud.gemspec b/vagrant_cloud.gemspec
    index 219d47d..c704aee 100644
    --- a/vagrant_cloud.gemspec
    +++ b/vagrant_cloud.gemspec
    @@ -15,7 +15,7 @@ Gem::Specification.new do |s|

       s.add_runtime_dependency 'excon', '~> 0.73'
       s.add_runtime_dependency 'log4r', '~> 1.1.10'
    -  s.add_runtime_dependency 'rexml', '~> 3.2.5'
    +  s.add_runtime_dependency 'rexml', '~> 3.3.0'

       s.add_development_dependency 'rake', '~> 12.3'
       s.add_development_dependency 'rspec', '~> 3.0'
  '';
in
{
  nixpkgs.overlays =
    let
      fontsOverlays = _: prev: {
        nerdfonts = prev.nerdfonts.override {
          fonts = [
            "CascadiaCode"
            "Hack"
            "JetBrainsMono"
            "IosevkaTerm"
            "Iosevka"
            "NerdFontsSymbolsOnly"
            "NotoSans"
          ];
        };
      };

      miscOverlays =
        _: prev:
        let
          inherit (prev) system;
        in
        {
          vagrant = prev.vagrant.overrideAttrs (old: {
            patches = patchForVagrant;
          });
        };
    in
    ([
      fontsOverlays
      # miscOverlays
    ])
    ++ (with inputs; [
      nixos-asahi.overlays.default
    ]);
}
