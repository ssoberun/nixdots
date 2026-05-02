{self, inputs, lib, ...}: {
  perSystem = {self', pkgs, lib, ...}: {
    packages.yazi = inputs.wrapper-modules.yazi.wrap {
      inherit pkgs;
      settings = {
        # settings here... 
      };
    };
  };
}
