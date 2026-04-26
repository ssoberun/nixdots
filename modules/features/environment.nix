{ inputs, self, pkgs, ... }: {
  perSystem = {self', pkgs, ...}: {
    packages.shell-environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        # unwrapped

        # wrapped
	self'.packages.git
      ];
    }; 
  };
}
