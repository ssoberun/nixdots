{ inputs, self, pkgs, ... }: {
  perSystem = {self', pkgs, ...}: {
    packages.shell-environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        # unwrapped
	pkgs.zoxide

        # wrapped
	self'.packages.git
	self'.packages.lf
	self'.packages.btop
      ];
      env = {
        EDITOR = "neovim";
      };
    }; 
  };
}
