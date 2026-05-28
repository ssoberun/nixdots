{ self, inputs, ... }:
{
  flake.nixosModules.zed =
    {
      config,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        zed-editor
      ];
    };
}
