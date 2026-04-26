# primary-user.nix
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences.user = {
      name = lib.mkOption {
        type = lib.types.str;
	default = "sam";
      };
    };
  };
}
