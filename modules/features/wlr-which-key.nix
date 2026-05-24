{
  self,
  inputs,
  lib,
  ...
}:
let
  mkWhichKey =
    pkgs: menu:
    (self.wrappersModules.which-key.apply {
      inherit pkgs;
      settings = {
        inherit menu;
        font = "Iosevka NF";
        background = "#282828d0";
        color = "#fbf1c7";
        border = "#8ec07c";
        separator = " ➜ ";
        border_width = 2;
        corner_r = 5;
        padding = 15;
        rows_per_column = 5;
        column_padding = 25;

        anchor = "center";
        margin_right = 0;
        margin_bottom = 5;
        margin_left = 5;
        margin_top = 0;
      };
    }).wrapper;
in
{
  flake.mkWhichKeyExe = pkgs: menu: lib.getExe (mkWhichKey pkgs menu);
  flake.wrappersModules.which-key = inputs.wrappers.lib.wrapModule (
    {
      config,
      lib,
      ...
    }:
    let
      yamlFormat = config.pkgs.formats.yaml { };
    in
    {
      options = {
        settings = lib.mkOption {
          type = yamlFormat.type;
        };
      };

      config = {
        package = config.pkgs.wlr-which-key;

        args = [
          (toString (yamlFormat.generate "config.yaml" config.settings))
        ];
      };
    }
  );
  # perSystem =
  #   {
  #     self',
  #     pkgs,
  #     lib,
  #     ...
  #   }:
  #   {
  #     packages.wlr-which-key = inputs.wrapper-modules.wrappers.wlr-which-key.wrap {
  #       inherit pkgs;
  #       settings = {
  #         font = "Iosevka NF";
  #         separator = " ➜ ";
  #         border_width = 2;
  #         corner_r = 5;
  #         padding = 15;
  #         rows_per_column = 5;
  #         column_padding = 25;
  #
  #         anchor = "bottom-right";
  #         margin_right = 0;
  #         margin-bottom = 5;
  #         margin_left = 5;
  #         margin_top = 0;
  #       };
  #     };
  #   };
}
