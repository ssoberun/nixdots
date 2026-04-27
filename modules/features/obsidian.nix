{self, inputs, ...}: {
  flake.nixosModules.obsidian = {self, pkgs, ...}: {
    environment.systemPackages = [
      pkgs.obsidian
    ];
  };
}
