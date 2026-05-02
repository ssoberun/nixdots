{self, inputs, ...}: {
  flake.nixosConfigurations.storage-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.x1-mcahine-configuration
    ];
  };
}
