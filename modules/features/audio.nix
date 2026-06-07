{ inputs, ... }:
{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.pavucontrol
      ];
    };
}
