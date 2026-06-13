{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  # noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  flake.nixosModules.noctalia =
    { pkgs, ... }:
    {
      # hj.xdg.config.files."noctalia/config.toml" = {
      #   generator = pkgs.formats.yaml { };
      #   value = {
      #
      #   };
      # };
    };
  # flake.noctaliaExe = lib.getExe (
  #   inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  # );
}
