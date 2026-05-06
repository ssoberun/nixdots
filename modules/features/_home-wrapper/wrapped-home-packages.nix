{ self, inputs, ... }:
{
  flake.nixosModules.wrapped-home-packages =
    { config, ... }:
    {
      imports = [
        inputs.hm-wrapper-modules.flakeModules.default
      ];
      hmWrappers.home-manager = inputs.home-manager;
      perSystem =
        { pkgs', ... }:
        {
          hmWrappers.programs = {
            bat.homeModules = [ self.modules.homeManager.bat ];
          };
        };
    };
}
