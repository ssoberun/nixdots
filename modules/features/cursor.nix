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

  flake.nixosModules.cursor = { config, ... }: {
    config = {
      environment.systemPackages = [
        config.custom.cursor.package
      ];

      hj.xdg.data.files = {
        "icons/${config.custom.cursor.name}".source =
          "${config.custom.cursor.package}/share/icons/${config.custom.cursor.name}";
      };
    };
  };
}
