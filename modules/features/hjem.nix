{ inputs, ... }:
{
  flake.modules.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      config.hjem = {
        clobberByDefault = true;
        linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
        users = {
          ${config.preferences.user.name} = {
            enable = true;
            xdg.config.files = {
              "zed/settings.json" = {
                generator = lib.generators.toJSON { };
                value = {
                };
              };
            };
          };
        };
      };
    };
}
