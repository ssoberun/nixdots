{ inputs, ... }:
{
  flake.nixosModules.vscode =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.vscodium
      ];
    };
}
