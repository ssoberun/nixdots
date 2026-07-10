{ inputs, self, ... }: {
  flake.nixosModules.mangowc-settings = {

  };
  perSystem = { self', pkgs, ... }: {
    packages.mangowc = inputs.wrapper-modules.wrappers.mangowc.wrap {
      inherit pkgs;
      imports = [ self.nixosModules.mangowc-settings ];
    };
  };
}
