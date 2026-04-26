{self, inputs, lib, ...}: {
  flake.nixosModules.fonts = {self, pkgs, ...}: {
    fonts = {
      packages = [
        pkgs._7-segment-font 
      ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    };
  };
}
