{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  flake.nixosModules.noctalia =
    { ... }:
    {
      environment.systemPackages = [
        noctaliaPackage
      ];
    };
  flake.noctaliaExe = lib.getExe noctaliaPackage;
}
