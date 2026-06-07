{
  inputs,
  ...
}:
{

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

      hj.xdg.config.files."zed/settings.json" = {
        generator = lib.generators.toJSON { };
        value = import ./_settings.nix;
      };
    };
}
