{ inputs, ... }:
{
  flake.nixosModules.core =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.pavucontrol
      ];
    };
}
