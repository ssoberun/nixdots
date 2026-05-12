{
  self,
  inputs,
  pkgs,
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      packages.fastfetch = inputs.wrapper-modules.wrappers.fastfetch.wrap {
        inherit pkgs;

      };
    };
}
