{ inputs, ... }:
{
  flake.nixosModules.core =
    { pkgs, config, ... }:
    {
      programs.ccache = {
        enable = true;
        cacheDir = "/var/cache/ccache";
      };

      nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" ];

      nixpkgs.overlays = [
        (_: prev: {
          openldap = prev.openldap.overrideAttrs {
            doCheck = !prev.stdenv.hostPlatform.isi686;
          };
        })
        # Configures ccache to write to our global system cache folder
        (final: prev: {
          ccacheWrapper = prev.ccacheWrapper.override {
            extraConfig = ''
              export CCACHE_COMPRESS=1
              export CCACHE_DIR="${config.programs.ccache.cacheDir}"
              export CCACHE_UMASK=007
            '';
          };
        })
        # Wraps the exact Wine package Lutris is consuming with ccacheStdenv
        (final: prev: {
          wineWow64Packages = prev.wineWow64Packages // {
            stagingFull = prev.wineWow64Packages.stagingFull.override {
              stdenv = prev.ccacheStdenv;
            };
          };
        })
      ];
    };
}
