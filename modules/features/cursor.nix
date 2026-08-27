{ lib, pkgs, ... }: {
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

  flake.nixosModules.cursor = { config, pkgs, ... }: {
    config =

      let
        cfg = config.custom.cursor;

        defaultCursorTheme = pkgs.runCommandLocal "default-cursor-theme" { } ''
          mkdir -p $out/share/icons
          ln -s ${cfg.package}/share/icons/${cfg.name} $out/share/icons/default
        '';
      in
      {
        environment.systemPackages = [
          cfg.package
          defaultCursorTheme
        ];

        hj.xdg.data.files = {
          # for the apple
          "icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";
          # set as default for fhs shit
          "icons/default".source = "${cfg.package}/share/icons/${cfg.name}";
        };
      };
  };
}
