{
  inputs,
  config,
  lib,
  ...
}:
{
  config.hjem = {
    users = {
      ${config.preferences.user.name} = {
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

  flake.nixosModules.zed =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        zed-editor
      ];

    };
}
