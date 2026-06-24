{ self, inputs, ... }: {
  flake.nixosConfigurations.study-rig = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.study-rig-configuration
    ];
  };
}
