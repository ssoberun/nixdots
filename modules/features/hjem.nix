{ inputs, ... }:
{
  flake.modules.nixos.base =
    { config, pkgs, ... }:
    {
      config = {
        hjem = {
          clobberByDefault = true;
          linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
        };
      };
    };
}
