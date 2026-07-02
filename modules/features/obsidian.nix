{ self, inputs, ... }: {
  flake.nixosModules.obsidian = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.obsidian

    ];
  };
}
