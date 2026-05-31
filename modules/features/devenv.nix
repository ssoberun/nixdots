{ inputs, ... }:
{
  flake.nixosModules.devenv =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        devenv
      ];
    };
}
