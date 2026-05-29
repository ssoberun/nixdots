{ inputs, ... }:
{
  flake.nixosModules.aichat =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [
        pkgs.aichat
      ];
    };
}
