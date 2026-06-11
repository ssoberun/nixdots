{
  self,
  inputs,
  pkgs,
  ...
}:
{
  # flake.nixosModules.kitty = { pkgs, ... }: {
  #   environment.systemPackages = [
  #     self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
  #   ];
  #
  #   environment.sessionVariables = {
  #     TERMINAL = "kitty";
  #   };
  # };

  flake.nixosModules.kitty =
    {
      self',
      pkgs,
      config,
      lib,
      ...
    }:
    {
      settings = {
        # cursor_trail = 3;
        background_blur = 1;
        background_opacity = 0.9;

        scrollback_lines = 2000;
        hide_window_decorations = true;
        confirm_os_window_close = 0;
        pixel_scroll = true;
      };
      extraConfig = ''
        include ~/.config/kitty/themes/noctalia.conf
      '';
    };
  #
  # perSystem = { self', pkgs, lib, ... }: {
  #   packages.kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
  #     inherit pkgs;
  #     imports = [self.nixosModules.kitty];
  #   };
  # };
}
