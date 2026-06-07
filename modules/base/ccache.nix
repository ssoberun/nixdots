{ inputs, ... }:
{
  flake.nixosModules.core =
    { pkgs, ... }:
    {
      programs.ccache = {
        enable = true;
        cacheDir = "/var/cache/ccache";
      };

      nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" ];
    };
}
