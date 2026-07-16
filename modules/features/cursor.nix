{ lib, ... }: {
  flake.nixosModules.core = { pkgs, ... }: {
    options.custom = {
      cursor = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.apple-cursor;
          description = "Package providing the cursor theme.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "macOS";
          description = "The cursor name within the package.";
        };

        size = lib.mkOption {
          type = lib.types.int;
          default = 28;
          description = "The cursor size.";
        };
      };
    };
  };

  flake.nixosModules.cursor =
    { pkgs, config, ... }:
    let
      cursor-table = config.options.custom.cursor;
    in
    {
      environment = {
        systemPackages = [
          cursor-table.package
        ];
      };

      hj.xdg.data.files = {
        "icons/${cursor-table.name}".source = "${cursor-table.package}/share/icons/${cursor-table.name}";
      };
    };
}
