{self, inputs, ...}: {
	flake.nixosConfigurations.x1-machine = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.x1-machine-configuration
			self.nixosModules.myHomeManager
		];
	};
}
