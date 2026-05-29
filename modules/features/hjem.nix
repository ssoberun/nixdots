{ inputs, ... }:
{
  flake.nixosModules.base =
    # flake.modules.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.hjem.nixosModules.default ];
      config.hjem = {
        clobberByDefault = true;
        linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
        users = {
          ${config.preferences.user.name} = {
            # enable = true;
            enable = false;
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
