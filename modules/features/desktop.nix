{self, ...}: {
 flake.nixosModules.desktop = {pkgs, ...}: {
   imports = [
     # wm
     self.nixosModules.niri
     self.nixosModules.GNOME

     # apps
     self.nixosModules.discord
     self.nixosModules.beeper
     self.nixosModules.obsidian

     # desktop visuals
     self.nixosModules.fonts
   ];
 };
}
