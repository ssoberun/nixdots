{ inputs, ... }:
{
  flake.nixosModules.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      user = config.preferences.user.name;
    in
    {
      imports = [
        inputs.hjem.nixosModules.default
        (inputs.nixpkgs.lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" user ])
      ];
      config.hjem = {
        clobberByDefault = true;
        linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
        users = {
          ${config.preferences.user.name} = {
            enable = true;
            # xdg.config.files = {
            #   "zed/settings.json" = {
            #     generator = lib.generators.toJSON { };
            #     value = {
            #     };
            #   };
            # };
          };
        };
      };
    };
}
