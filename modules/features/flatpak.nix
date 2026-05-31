{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { pkgs, ... }:
    {
      services.flatpak = {
        enable = true;
        packages = [

        ];
      };
    };
}
