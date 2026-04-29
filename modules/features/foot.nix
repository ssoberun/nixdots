{ self, inputs, pkgs, ... }: {
  flake.nixosModules.foot = { self', pkgs, config, lib, ... }: {
    settings = {
    };
  };

  perSystem = { self', pkgs, lib, ... }: {
    packages.foot = inputs.wrapper-modules.wrappers.foot.wrap {
      inherit pkgs;
      imports = [self.nixosModules.foot];
    };
  }; 
}
