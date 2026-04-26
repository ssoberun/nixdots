{self, inputs, lib, ...}: {
  flake.nixosModules.fonts = {self, pkgs, ...}: {
    fonts = {
      fontConfig = {
        defaultFonts = {
	  serif = ["Ubuntu Sans"];
	  sansSerif = ["Ubuntu Sans"];
	  monospace = ["JetBrainsMono Nerd Font"];
	};
      };
      packages = [
        pkgs.ubuntu-sans
	pkgs.corefonts
	pkgs.unifont
	pkgs.iosevka
        pkgs._7-segment-font 
      ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    };
  };
}
